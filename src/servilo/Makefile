# Copyright (c) 2009-2010 Satoshi Nakamoto
# Copyright (c) 2013 Primecoind developers
# Kopirajto (c) 2017 Chapman Shoop
# Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

LINK:=$(CXX)

DEFS=-D_FILE_OFFSET_BITS=64 -DBOOST_LOG_DYN_LINK

DEFS += $(addprefix -I,$(CURDIR) $(CURDIR)/obj $(BOOST_INCLUDE_PATH) $(BDB_INCLUDE_PATH) $(OPENSSL_INCLUDE_PATH))
LIBS = $(addprefix -L,$(BOOST_LIB_PATH) $(BDB_LIB_PATH) $(OPENSSL_LIB_PATH))

TESTDEFS = -DTEST_DATA_DIR=$(abspath test/data)

LMODE = dynamic
LMODE2 = dynamic
ifdef STATIC
	LMODE = static
	ifeq (${STATIC}, all)
		LMODE2 = static
	endif
else
	TESTDEFS += -DBOOST_TEST_DYN_LINK
endif

LIBS += \
   -l boost_chrono \
   -l boost_filesystem \
   -l boost_log \
   -l boost_program_options \
   -l boost_system \
   -l boost_thread \
   -l boost_timer \
   -l db_cxx \
   -l ssl \
   -l crypto \
   -l gmp \
   -l leveldb \
   -l memenv \
   -l gcov

TESTLIBS += -l boost_unit_test_framework

LIBS += \
   -l z \
   -l dl \
   -l pthread

# Hardening
# Make some classes of vulnerabilities unexploitable in case one is discovered.
#
    # This is a workaround for Ubuntu bug #691722, the default -fstack-protector causes
    # -fstack-protector-all to be ignored unless -fno-stack-protector is used first.
    # see: https://bugs.launchpad.net/ubuntu/+source/gcc-4.5/+bug/691722
    HARDENING=-fno-stack-protector

    # Stack Canaries
    # Put numbers at the beginning of each stack frame and check that they are the same.
    # If a stack buffer if overflowed, it writes over the canary number and then on return
    # when that number is checked, it won't be the same and the program will exit with
    # a "Stack smashing detected" error instead of being exploited.
    HARDENING+=-fstack-protector-all -Wstack-protector

    # Make some important things such as the global offset table read only as soon as
    # the dynamic linker is finished building it. This will prevent overwriting of addresses
    # which would later be jumped to.
    LDHARDENING+=-Wl,-z,relro -Wl,-z,now

    # -D_FORTIFY_SOURCE=2 does some checking for potentially exploitable code patterns in
    # the source such overflowing a statically defined buffer.
    HARDENING+=-D_FORTIFY_SOURCE=2
#

# CXXFLAGS can be specified on the make command line, so we use xCXXFLAGS that only
# adds some defaults in front. Unfortunately, CXXFLAGS=... $(CXXFLAGS) does not work.
xCXXFLAGS=\
    $(DEFS) \
    $(HARDENING) \
    $(CXXFLAGS) \
    -O2 \
    -Wall \
    -Wextra \
    -Werror \
    -Wformat \
    -Wformat-security \
    -Wno-unused-parameter \
    -pthread \
    -std=c++14

# LDFLAGS can be specified on the make command line, so we use xLDFLAGS that only
# adds some defaults in front. Unfortunately, LDFLAGS=... $(LDFLAGS) does not work.
xLDFLAGS=$(LDHARDENING) $(LDFLAGS)

OBJS=\
    obj/version.o \
    obj/netbase.o \
    obj/addrman.o \
    obj/key.o \
    obj/db.o \
    obj/init.o \
    obj/main.o \
    obj/net.o \
    obj/protocol.o \
    obj/script.o \
    obj/sync.o \
    obj/util.o \
    obj/hash.o \
    obj/bloom.o \
    obj/leveldb.o \
    obj/txdb.o \
    obj/prime.o

# auto-generated dependencies:
-include obj/*.P
-include obj-test/*.P

obj/%.o: %.cpp
	$(CXX) -c $(xCXXFLAGS) -MMD -MF $(@:%.o=%.d) -o $@ $<
	@cp $(@:%.o=%.d) $(@:%.o=%.P); \
	  sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
	      -e '/^$$/ d' -e 's/$$/ :/' < $(@:%.o=%.d) >> $(@:%.o=%.P); \
	  rm -f $(@:%.o=%.d)


TESTOBJS := $(patsubst test/%.cpp,obj-test/%.o,$(wildcard test/*.cpp))

obj-test/%.o: test/%.cpp
	$(CXX) -c $(TESTDEFS) $(xCXXFLAGS) -MMD -MF $(@:%.o=%.d) -o $@ $<
	@cp $(@:%.o=%.d) $(@:%.o=%.P); \
	  sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
	      -e '/^$$/ d' -e 's/$$/ :/' < $(@:%.o=%.d) >> $(@:%.o=%.P); \
	  rm -f $(@:%.o=%.d)

servilo: $(OBJS:obj/%=obj/%)
	$(LINK) $(xCXXFLAGS) -o $@ $^ $(xLDFLAGS) $(LIBS)

testa-servilo: $(TESTOBJS) $(filter-out obj/init.o,$(OBJS:obj/%=obj/%))
	$(LINK) $(xCXXFLAGS) -o $@ $(LIBPATHS) $^ $(TESTLIBS) $(xLDFLAGS) $(LIBS)

# Docker
.PHONY: docker-build
docker-build:
	docker build --build-arg J=4 . -t primmonero-servilo

.PHONY: docker-check
docker-check: docker-build
	docker run --rm primmonero-servilo cppcheck --enable=all ./

.PHONY: docker-test
docker-test: docker-build
	docker run --rm primmonero-servilo ./testa-servilo
