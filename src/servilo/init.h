// Copyright (c) 2009-2010 Satoshi Nakamoto
// Copyright (c) 2009-2012 The Bitcoin developers
// Kopirajto 2017 Chapman Shoop
// Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

#ifndef __INIT_H__
#define __INIT_H__

#include <boost/thread/thread.hpp>

bool AppInit2(boost::thread_group &);
std::string HelpMessage();
void Shutdown();
void StartShutdown();

#endif // __INIT_H__
