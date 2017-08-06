// Copyright (c) 2012 The Bitcoin developers
// Copyright (c) 2013 Primecoin developers
// Kopirajto (c) 2017 Chapman Shoop
// Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

#ifndef __VERSION_H__
#define __VERSION_H__

#include <string>

static const int VERSION_MAJOR = 1;
static const int VERSION_MINOR = 0;
static const int VERSION_PATCH = 0;

static const int VERSION =
                           1000000 * VERSION_MAJOR
                         +   10000 * VERSION_MINOR
                         +     100 * VERSION_PATCH;

static const int PROTOCOL_VERSION = 70001;

// earlier versions not supported as of Feb 2012, and are disconnected
static const int MIN_PROTO_VERSION = 209;

// nTime field added to CAddress, starting with this version;
// if possible, avoid requesting addresses nodes older than this
static const int CADDR_TIME_VERSION = 31402;

// only request blocks from nodes outside this range of versions
static const int NOBLKS_VERSION_START = 32000;
static const int NOBLKS_VERSION_END = 32400;

// BIP 0031, pong message, is enabled for all versions AFTER this one
static const int BIP0031_VERSION = 60000;

// "mempool" command, enhanced "getdata" behavior starts with this version:
static const int MEMPOOL_GD_VERSION = 60002;

std::string ServiloNomo();

#endif // __VERSION_H__
