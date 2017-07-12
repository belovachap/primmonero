# Kopirajto 2017 Chapman Shoop
# Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

TEMPLATE = app
TARGET = testa-primmonera-monujo
VERSION = 0.0.0
INCLUDEPATH += ./ ../servilo
QT += network
DEFINES += QT_GUI BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE
CONFIG += no_include_pwd
CONFIG += thread

# Dependency library locations can be customized with:
#    BOOST_INCLUDE_PATH, BOOST_LIB_PATH, BDB_INCLUDE_PATH,
#    BDB_LIB_PATH, OPENSSL_INCLUDE_PATH and OPENSSL_LIB_PATH respectively

OBJECTS_DIR = build
MOC_DIR = build
UI_DIR = build

# use: qmake "RELEASE=1"
contains(RELEASE, 1) {
    # Mac: compile for maximum compatibility (10.5, 32-bit)
    # Primecoin HP: support both i386 and x86_64 for best performance and compatibility
    # Primecoin HP: require 10.6 at the minimum
    macx:QMAKE_CXXFLAGS += -mmacosx-version-min=10.6 -arch i386 -arch x86_64 -isysroot /Developer/SDKs/MacOSX10.6.sdk
    macx:QMAKE_CFLAGS += -mmacosx-version-min=10.6 -arch i386 -arch x86_64 -isysroot /Developer/SDKs/MacOSX10.6.sdk
    macx:QMAKE_OBJECTIVE_CFLAGS += -mmacosx-version-min=10.6 -arch i386 -arch x86_64 -isysroot /Developer/SDKs/MacOSX10.6.sdk

    !win32:!macx {
        # Linux: static link and extra security (see: https://wiki.debian.org/Hardening)
        LIBS += -Wl,-Bstatic -Wl,-z,relro -Wl,-z,now

	# Linux: Enable bundling libgmp.so with the binary
	LIBS += -Wl,-rpath,\\\$$ORIGIN
    }
}

# for extra security against potential buffer overflows: enable GCCs Stack Smashing Protection
QMAKE_CXXFLAGS *= -fstack-protector-all
QMAKE_LFLAGS *= -fstack-protector-all
# for extra security (see: https://wiki.debian.org/Hardening): this flag is GCC compiler-specific
QMAKE_CXXFLAGS *= -D_FORTIFY_SOURCE=2

# use: qmake "USE_DBUS=1"
contains(USE_DBUS, 1) {
    message(Building with DBUS (Freedesktop notifications) support)
    DEFINES += USE_DBUS
    QT += dbus
}

# use: qmake "USE_IPV6=1" ( enabled by default; default)
#  or: qmake "USE_IPV6=0" (disabled by default)
#  or: qmake "USE_IPV6=-" (not supported)
contains(USE_IPV6, -) {
    message(Building without IPv6 support)
} else {
    count(USE_IPV6, 0) {
        USE_IPV6=1
    }
    DEFINES += USE_IPV6=$$USE_IPV6
}

contains(BITCOIN_NEED_QT_PLUGINS, 1) {
    DEFINES += BITCOIN_NEED_QT_PLUGINS
    contains(BITCOIN_QT_NO_CODECS, 1) {
        DEFINES += BITCOIN_QT_NO_CODECS
    } else {
        QTPLUGIN += qcncodecs qjpcodecs qtwcodecs qkrcodecs
    }
    QTPLUGIN += qtaccessiblewidgets
}

# Regenerate build/build.h
genbuild.depends = FORCE
genbuild.commands = cd $$PWD; /bin/sh ../../share/genbuild.sh $$OUT_PWD/build/build.h
genbuild.target = $$OUT_PWD/build/build.h
PRE_TARGETDEPS += $$OUT_PWD/build/build.h
QMAKE_EXTRA_TARGETS += genbuild
DEFINES += HAVE_BUILD_INFO

QMAKE_CXXFLAGS_WARN_ON=\
    -fdiagnostics-show-option \
    -Wall \
    -Wextra \
    -Werror \
    -Wformat \
    -Wformat-security \
    -Wno-unused-parameter \
    -Wstack-protector

# Input
DEPENDPATH +=  ./ ../servilo
HEADERS += bitcoingui.h \
    transactiontablemodel.h \
    addresstablemodel.h \
    sendcoinsdialog.h \
    addressbookpage.h \
    aboutdialog.h \
    editaddressdialog.h \
    bitcoinaddressvalidator.h \
    ../servilo/alert.h \
    ../servilo/addrman.h \
    ../servilo/base58.h \
    ../servilo/bignum.h \
    ../servilo/checkpoints.h \
    ../servilo/compat.h \
    ../servilo/sync.h \
    ../servilo/util.h \
    ../servilo/hash.h \
    ../servilo/uint256.h \
    ../servilo/serialize.h \
    ../servilo/main.h \
    ../servilo/net.h \
    ../servilo/key.h \
    ../servilo/db.h \
    ../servilo/walletdb.h \
    ../servilo/script.h \
    ../servilo/init.h \
    ../servilo/bloom.h \
    ../servilo/mruset.h \
    ../servilo/checkqueue.h \
    clientmodel.h \
    guiutil.h \
    transactionrecord.h \
    guiconstants.h \
    monitoreddatamapper.h \
    transactiondesc.h \
    transactiondescdialog.h \
    bitcoinamountfield.h \
    ../servilo/wallet.h \
    ../servilo/keystore.h \
    transactionfilterproxy.h \
    transactionview.h \
    walletmodel.h \
    walletview.h \
    walletstack.h \
    walletframe.h \
    ../servilo/bitcoinrpc.h \
    overviewpage.h \
    csvmodelwriter.h \
    ../servilo/crypter.h \
    sendcoinsentry.h \
    qvalidatedlineedit.h \
    bitcoinunits.h \
    qvaluecombobox.h \
    askpassphrasedialog.h \
    ../servilo/protocol.h \
    notificator.h \
    paymentserver.h \
    ../servilo/allocators.h \
    ../servilo/ui_interface.h \
    ../servilo/version.h \
    ../servilo/netbase.h \
    ../servilo/clientversion.h \
    ../servilo/txdb.h \
    ../servilo/leveldb.h \
    ../servilo/threadsafety.h \
    ../servilo/limitedmap.h \
    ../servilo/prime.h \
    ../servilo/checkpointsync.h

SOURCES +=\
    bitcoingui.cpp \
    transactiontablemodel.cpp \
    addresstablemodel.cpp \
    sendcoinsdialog.cpp \
    addressbookpage.cpp \
    aboutdialog.cpp \
    editaddressdialog.cpp \
    bitcoinaddressvalidator.cpp \
    ../servilo/alert.cpp \
    ../servilo/version.cpp \
    ../servilo/sync.cpp \
    ../servilo/util.cpp \
    ../servilo/hash.cpp \
    ../servilo/netbase.cpp \
    ../servilo/key.cpp \
    ../servilo/script.cpp \
    ../servilo/main.cpp \
    ../servilo/init.cpp \
    ../servilo/net.cpp \
    ../servilo/bloom.cpp \
    ../servilo/checkpoints.cpp \
    ../servilo/addrman.cpp \
    ../servilo/db.cpp \
    ../servilo/walletdb.cpp \
    clientmodel.cpp \
    guiutil.cpp \
    transactionrecord.cpp \
    transactiondesc.cpp \
    transactiondescdialog.cpp \
    bitcoinamountfield.cpp \
    ../servilo/wallet.cpp \
    ../servilo/keystore.cpp \
    transactionfilterproxy.cpp \
    transactionview.cpp \
    walletmodel.cpp \
    walletview.cpp \
    walletstack.cpp \
    walletframe.cpp \
    ../servilo/bitcoinrpc.cpp \
    ../servilo/rpcdump.cpp \
    ../servilo/rpcnet.cpp \
    ../servilo/rpcmining.cpp \
    ../servilo/rpcwallet.cpp \
    ../servilo/rpcblockchain.cpp \
    ../servilo/rpcrawtransaction.cpp \
    overviewpage.cpp \
    csvmodelwriter.cpp \
    ../servilo/crypter.cpp \
    sendcoinsentry.cpp \
    qvalidatedlineedit.cpp \
    bitcoinunits.cpp \
    qvaluecombobox.cpp \
    askpassphrasedialog.cpp \
    ../servilo/protocol.cpp \
    notificator.cpp \
    paymentserver.cpp \
    ../servilo/noui.cpp \
    ../servilo/leveldb.cpp \
    ../servilo/txdb.cpp \
    ../servilo/prime.cpp \
    ../servilo/checkpointsync.cpp

RESOURCES += bitcoin.qrc

FORMS += forms/sendcoinsdialog.ui \
    forms/addressbookpage.ui \
    forms/aboutdialog.ui \
    forms/editaddressdialog.ui \
    forms/transactiondescdialog.ui \
    forms/overviewpage.ui \
    forms/sendcoinsentry.ui \
    forms/askpassphrasedialog.ui

# Testa programo transpasoj
SOURCES += test/test_main.cpp \
           test/uritests.cpp
HEADERS += test/uritests.h
DEPENDPATH += test
QT += testlib

# "Other files" to show in Qt Creator
OTHER_FILES += README.md \
    doc/*.rst \
    doc/*.txt \
    res/bitcoin-qt.rc \
    ../servilo/test/*.cpp \
    ../servilo/test/*.h \
    test/*.cpp \
    test/*.h

# platform specific defaults, if not overridden on command line
isEmpty(BOOST_LIB_SUFFIX) {
    macx:BOOST_LIB_SUFFIX = -mt
    win32:BOOST_LIB_SUFFIX = -mgw44-mt-s-1_50
}

isEmpty(BOOST_THREAD_LIB_SUFFIX) {
    BOOST_THREAD_LIB_SUFFIX = $$BOOST_LIB_SUFFIX
}

isEmpty(BDB_LIB_PATH) {
    macx:BDB_LIB_PATH = /opt/local/lib/db48
}

isEmpty(BDB_LIB_SUFFIX) {
    macx:BDB_LIB_SUFFIX = -4.8
}

isEmpty(BDB_INCLUDE_PATH) {
    macx:BDB_INCLUDE_PATH = /opt/local/include/db48
}

isEmpty(BOOST_LIB_PATH) {
    macx:BOOST_LIB_PATH = /opt/local/lib
}

isEmpty(BOOST_INCLUDE_PATH) {
    macx:BOOST_INCLUDE_PATH = /opt/local/include
}

DEFINES += LINUX
LIBS += -lrt
# _FILE_OFFSET_BITS=64 lets 32-bit fopen transparently support large files.
DEFINES += _FILE_OFFSET_BITS=64

# Set libraries and includes at end, to use platform-defined defaults if not overridden
INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH
LIBS += $$join(BOOST_LIB_PATH,,-L,) $$join(BDB_LIB_PATH,,-L,) $$join(OPENSSL_LIB_PATH,,-L,) $$join(QRENCODE_LIB_PATH,,-L,)
LIBS += -lssl -lcrypto -ldb_cxx$$BDB_LIB_SUFFIX -lleveldb -lmemenv
LIBS += -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread$$BOOST_THREAD_LIB_SUFFIX -lboost_chrono$$BOOST_LIB_SUFFIX -lboost_timer$$BOOST_LIB_SUFFIX
# Link dynamically against GMP
LIBS += -Wl,-Bdynamic -lgmp

contains(RELEASE, 1) {
    # Linux: turn dynamic linking back on for c/c++ runtime libraries
    LIBS += -Wl,-Bdynamic
}
