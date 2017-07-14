# Kopirajto 2017 Chapman Shoop
# Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

TEMPLATE = app
TARGET = testa-primmonera-monujo
VERSION = 0.0.0
INCLUDEPATH += ./
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
DEPENDPATH +=  ./ ../
HEADERS += \
    addressbookpage.h \
    aboutdialog.h \
    addresstablemodel.h \
    addrman.h \
    alert.h \
    allocators.h \
    askpassphrasedialog.h \
    base58.h \
    bignum.h \
    bitcoinaddressvalidator.h \
    bitcoinamountfield.h \
    bitcoingui.h \
    bitcoinunits.h \
    bloom.h \
    checkpoints.h \
    checkpointsync.h \
    checkqueue.h \
    clientmodel.h \
    clientversion.h \
    compat.h \
    crypter.h \
    csvmodelwriter.h \
    db.h \
    editaddressdialog.h \
    guiconstants.h \
    guiutil.h \
    hash.h \
    init.h \
    key.h \
    keystore.h \
    leveldb.h \
    limitedmap.h \
    main.h \
    monitoreddatamapper.h \
    mruset.h \
    net.h \
    netbase.h \
    notificator.h \
    overviewpage.h \
    paymentserver.h \
    prime.h \
    protocol.h \
    qvalidatedlineedit.h \
    qvaluecombobox.h \
    script.h \
    sendcoinsdialog.h \
    sendcoinsentry.h \
    serialize.h \
    sync.h \
    threadsafety.h \
    transactiondesc.h \
    transactiondescdialog.h \
    transactionfilterproxy.h \
    transactionrecord.h \
    transactiontablemodel.h \
    transactionview.h \
    txdb.h \
    ui_interface.h \
    uint256.h \
    util.h \
    version.h \
    wallet.h \
    walletdb.h \
    walletframe.h \
    walletmodel.h \
    walletstack.h \
    walletview.h

SOURCES += \
    aboutdialog.cpp \
    addressbookpage.cpp \
    addresstablemodel.cpp \
    addrman.cpp \
    alert.cpp \
    askpassphrasedialog.cpp \
    bitcoinaddressvalidator.cpp \
    bitcoinamountfield.cpp \
    bitcoingui.cpp \
    bitcoinunits.cpp \
    bloom.cpp \
    checkpoints.cpp \
    checkpointsync.cpp \
    clientmodel.cpp \
    crypter.cpp \
    csvmodelwriter.cpp \
    db.cpp \
    editaddressdialog.cpp \
    guiutil.cpp \
    hash.cpp \
    init.cpp \
    key.cpp \
    keystore.cpp \
    leveldb.cpp \
    monitoreddatamapper.cpp \
    net.cpp \
    netbase.cpp \
    notificator.cpp \
    main.cpp \
    overviewpage.cpp \
    paymentserver.cpp \
    prime.cpp \
    protocol.cpp \
    qvalidatedlineedit.cpp \
    qvaluecombobox.cpp \
    script.cpp \
    sendcoinsdialog.cpp \
    sendcoinsentry.cpp \
    sync.cpp \
    transactiondesc.cpp \
    transactiondescdialog.cpp \
    transactionfilterproxy.cpp \
    transactiontablemodel.cpp \
    transactionrecord.cpp \
    transactionview.cpp \
    txdb.cpp \
    util.cpp \
    version.cpp \
    wallet.cpp \
    walletdb.cpp \
    walletframe.cpp \
    walletmodel.cpp \
    walletstack.cpp \
    walletview.cpp

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
QT += testlib

# "Other files" to show in Qt Creator
OTHER_FILES += README.md \
    doc/*.rst \
    doc/*.txt \
    res/bitcoin-qt.rc \
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
