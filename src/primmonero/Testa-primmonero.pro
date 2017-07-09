# Kopirajto 2017 Chapman Shoop
# Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

TEMPLATE = app
TARGET = testa-primmonero
VERSION = 0.0.0
INCLUDEPATH += ./ ../primmonerad ../primmonerad/json
QT += network
DEFINES += QT_GUI BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE
CONFIG += no_include_pwd
CONFIG += thread

# avoid warnings about FD_SETSIZE being redefined
# Windows x64 needs BOOST_USE_WINDOWS_H and WIN32_LEAN_AND_MEAN
win32:DEFINES += FD_SETSIZE=1024 BOOST_USE_WINDOWS_H WIN32_LEAN_AND_MEAN WINVER=0x500

# for boost 1.37, add -mt to the boost libraries
# use: qmake BOOST_LIB_SUFFIX=-mt
# for boost thread win32 with _win32 sufix
# use: BOOST_THREAD_LIB_SUFFIX=_win32-...
# or when linking against a specific BerkelyDB version: BDB_LIB_SUFFIX=-4.8

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

!win32 {
    # for extra security against potential buffer overflows: enable GCCs Stack Smashing Protection
    QMAKE_CXXFLAGS *= -fstack-protector-all
    QMAKE_LFLAGS *= -fstack-protector-all
    # Exclude on Windows cross compile with MinGW 4.2.x, as it will result in a non-working executable!
    # This can be enabled for Windows, when we switch to MinGW >= 4.4.x.
}
# for extra security (see: https://wiki.debian.org/Hardening): this flag is GCC compiler-specific
QMAKE_CXXFLAGS *= -D_FORTIFY_SOURCE=2
# for extra security on Windows: enable ASLR and DEP via GCC linker flags
win32:QMAKE_LFLAGS *= -Wl,--dynamicbase -Wl,--nxcompat
# on Windows x86: enable GCC large address aware linker flag
!contains(QMAKE_HOST.arch, x86_64) {
	win32:QMAKE_LFLAGS *= -Wl,--large-address-aware
}

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

INCLUDEPATH += ../primmonerad/leveldb/include ../primmonerad/leveldb/helpers
LIBS += $$PWD/../primmonerad/leveldb/libleveldb.a $$PWD/../primmonerad/leveldb/libmemenv.a
!win32 {
    # we use QMAKE_CXXFLAGS_RELEASE even without RELEASE=1 because we use RELEASE to indicate linking preferences not -O preferences
    genleveldb.commands = cd $$PWD/../primmonerad/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a
} else {
    # make an educated guess about what the ranlib command is called
    isEmpty(QMAKE_RANLIB) {
        QMAKE_RANLIB = $$replace(QMAKE_STRIP, strip, ranlib)
    }
    LIBS += -lshlwapi
    genleveldb.commands = cd $$PWD/../primmonerad/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX TARGET_OS=OS_WINDOWS_CROSSCOMPILE $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a && $$QMAKE_RANLIB $$PWD/../primmonerad/leveldb/libleveldb.a && $$QMAKE_RANLIB $$PWD/../primmonerad/leveldb/libmemenv.a
}
genleveldb.target = $$PWD/../primmonerad/leveldb/libleveldb.a
genleveldb.depends = FORCE
PRE_TARGETDEPS += $$PWD/../primmonerad/leveldb/libleveldb.a
QMAKE_EXTRA_TARGETS += genleveldb
# Gross ugly hack that depends on qmake internals, unfortunately there is no other way to do it.
QMAKE_CLEAN += $$PWD/../primmonerad/leveldb/libleveldb.a; cd $$PWD/../primmonerad/leveldb ; $(MAKE) clean

# Regenerate build/build.h
genbuild.depends = FORCE
genbuild.commands = cd $$PWD; /bin/sh ../../share/genbuild.sh $$OUT_PWD/build/build.h
genbuild.target = $$OUT_PWD/build/build.h
PRE_TARGETDEPS += $$OUT_PWD/build/build.h
QMAKE_EXTRA_TARGETS += genbuild
DEFINES += HAVE_BUILD_INFO

QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wformat -Wformat-security -Wno-unused-parameter -Wstack-protector

# Input
DEPENDPATH +=  ./ ../primmonerad ../primmonerad/json
HEADERS += bitcoingui.h \
    transactiontablemodel.h \
    addresstablemodel.h \
    sendcoinsdialog.h \
    addressbookpage.h \
    aboutdialog.h \
    editaddressdialog.h \
    bitcoinaddressvalidator.h \
    ../primmonerad/alert.h \
    ../primmonerad/addrman.h \
    ../primmonerad/base58.h \
    ../primmonerad/bignum.h \
    ../primmonerad/checkpoints.h \
    ../primmonerad/compat.h \
    ../primmonerad/sync.h \
    ../primmonerad/util.h \
    ../primmonerad/hash.h \
    ../primmonerad/uint256.h \
    ../primmonerad/serialize.h \
    ../primmonerad/main.h \
    ../primmonerad/net.h \
    ../primmonerad/key.h \
    ../primmonerad/db.h \
    ../primmonerad/walletdb.h \
    ../primmonerad/script.h \
    ../primmonerad/init.h \
    ../primmonerad/bloom.h \
    ../primmonerad/mruset.h \
    ../primmonerad/checkqueue.h \
    ../primmonerad/json/json_spirit_writer_template.h \
    ../primmonerad/json/json_spirit_writer.h \
    ../primmonerad/json/json_spirit_value.h \
    ../primmonerad/json/json_spirit_utils.h \
    ../primmonerad/json/json_spirit_stream_reader.h \
    ../primmonerad/json/json_spirit_reader_template.h \
    ../primmonerad/json/json_spirit_reader.h \
    ../primmonerad/json/json_spirit_error_position.h \
    ../primmonerad/json/json_spirit.h \
    clientmodel.h \
    guiutil.h \
    transactionrecord.h \
    guiconstants.h \
    monitoreddatamapper.h \
    transactiondesc.h \
    transactiondescdialog.h \
    bitcoinamountfield.h \
    ../primmonerad/wallet.h \
    ../primmonerad/keystore.h \
    transactionfilterproxy.h \
    transactionview.h \
    walletmodel.h \
    walletview.h \
    walletstack.h \
    walletframe.h \
    ../primmonerad/bitcoinrpc.h \
    overviewpage.h \
    csvmodelwriter.h \
    ../primmonerad/crypter.h \
    sendcoinsentry.h \
    qvalidatedlineedit.h \
    bitcoinunits.h \
    qvaluecombobox.h \
    askpassphrasedialog.h \
    ../primmonerad/protocol.h \
    notificator.h \
    paymentserver.h \
    ../primmonerad/allocators.h \
    ../primmonerad/ui_interface.h \
    rpcconsole.h \
    ../primmonerad/version.h \
    ../primmonerad/netbase.h \
    ../primmonerad/clientversion.h \
    ../primmonerad/txdb.h \
    ../primmonerad/leveldb.h \
    ../primmonerad/threadsafety.h \
    ../primmonerad/limitedmap.h \
    splashscreen.h \
    ../primmonerad/prime.h \
    ../primmonerad/checkpointsync.h

SOURCES += bitcoin.cpp \
    bitcoingui.cpp \
    transactiontablemodel.cpp \
    addresstablemodel.cpp \
    sendcoinsdialog.cpp \
    addressbookpage.cpp \
    aboutdialog.cpp \
    editaddressdialog.cpp \
    bitcoinaddressvalidator.cpp \
    ../primmonerad/alert.cpp \
    ../primmonerad/version.cpp \
    ../primmonerad/sync.cpp \
    ../primmonerad/util.cpp \
    ../primmonerad/hash.cpp \
    ../primmonerad/netbase.cpp \
    ../primmonerad/key.cpp \
    ../primmonerad/script.cpp \
    ../primmonerad/main.cpp \
    ../primmonerad/init.cpp \
    ../primmonerad/net.cpp \
    ../primmonerad/bloom.cpp \
    ../primmonerad/checkpoints.cpp \
    ../primmonerad/addrman.cpp \
    ../primmonerad/db.cpp \
    ../primmonerad/walletdb.cpp \
    clientmodel.cpp \
    guiutil.cpp \
    transactionrecord.cpp \
    monitoreddatamapper.cpp \
    transactiondesc.cpp \
    transactiondescdialog.cpp \
    bitcoinamountfield.cpp \
    ../primmonerad/wallet.cpp \
    ../primmonerad/keystore.cpp \
    transactionfilterproxy.cpp \
    transactionview.cpp \
    walletmodel.cpp \
    walletview.cpp \
    walletstack.cpp \
    walletframe.cpp \
    ../primmonerad/bitcoinrpc.cpp \
    ../primmonerad/rpcdump.cpp \
    ../primmonerad/rpcnet.cpp \
    ../primmonerad/rpcmining.cpp \
    ../primmonerad/rpcwallet.cpp \
    ../primmonerad/rpcblockchain.cpp \
    ../primmonerad/rpcrawtransaction.cpp \
    overviewpage.cpp \
    csvmodelwriter.cpp \
    ../primmonerad/crypter.cpp \
    sendcoinsentry.cpp \
    qvalidatedlineedit.cpp \
    bitcoinunits.cpp \
    qvaluecombobox.cpp \
    askpassphrasedialog.cpp \
    ../primmonerad/protocol.cpp \
    notificator.cpp \
    paymentserver.cpp \
    rpcconsole.cpp \
    ../primmonerad/noui.cpp \
    ../primmonerad/leveldb.cpp \
    ../primmonerad/txdb.cpp \
    splashscreen.cpp \
    ../primmonerad/prime.cpp \
    ../primmonerad/checkpointsync.cpp

RESOURCES += bitcoin.qrc

FORMS += forms/sendcoinsdialog.ui \
    forms/addressbookpage.ui \
    forms/aboutdialog.ui \
    forms/editaddressdialog.ui \
    forms/transactiondescdialog.ui \
    forms/overviewpage.ui \
    forms/sendcoinsentry.ui \
    forms/askpassphrasedialog.ui \
    forms/rpcconsole.ui

# Testa programo transpasoj
SOURCES += test/test_main.cpp \
           test/uritests.cpp
HEADERS += test/uritests.h
DEPENDPATH += test
QT += testlib
TARGET = testa-primmonero
DEFINES += TESTA_PROGRAMO

# "Other files" to show in Qt Creator
OTHER_FILES += README.md \
    doc/*.rst \
    doc/*.txt \
    res/bitcoin-qt.rc \
    ../primmonerad/test/*.cpp \
    ../primmonerad/test/*.h \
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
LIBS += -lssl -lcrypto -ldb_cxx$$BDB_LIB_SUFFIX
# -lgdi32 has to happen after -lcrypto (see  #681)
win32:LIBS += -lws2_32 -lshlwapi -lmswsock -lole32 -loleaut32 -luuid -lgdi32
LIBS += -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread$$BOOST_THREAD_LIB_SUFFIX -lboost_chrono$$BOOST_LIB_SUFFIX -lboost_timer$$BOOST_LIB_SUFFIX
# Link dynamically against GMP
!macx:LIBS += -Wl,-Bdynamic -lgmp
else:LIBS += -lgmp

contains(RELEASE, 1) {
    !win32:!macx {
        # Linux: turn dynamic linking back on for c/c++ runtime libraries
        LIBS += -Wl,-Bdynamic
    }
}
