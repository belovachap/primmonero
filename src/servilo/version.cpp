// Copyright (c) 2012 The Bitcoin developers
// Copyright (c) 2013 Primecoin developers
// Kopirajto (c) 2017 Chapman Shoop
// Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

#include <sstream>
#include <string>

#include "version.h"

std::string ServiloNomo() {
	std::ostringstream ss;
	ss << "Primmonero " << VERSION_MAJOR << "." << VERSION_MINOR << "." << VERSION_PATCH;
    return ss.str();
}
