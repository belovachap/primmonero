// Copyright (c) 2013 Primecoin developers
// Kopirajto 2017 Chapman Shoop
// Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.

#ifndef __PRIME_H__
#define __PRIME_H__

#include "main.h"
#include "base58.h"
    
#include <gmp.h>
#include <gmpxx.h>
#include <bitset>
#include <boost/timer/timer.hpp>

/**********************/
/* PRIMECOIN PROTOCOL */
/**********************/

extern std::vector<unsigned int> vPrimes;
static const unsigned int nMaxSieveExtensions = 20;
static const unsigned int nMinSieveExtensions = 0;
static const unsigned int nDefaultSieveExtensions = 10;
static const unsigned int nDefaultSieveExtensionsTestnet = 4;
extern unsigned int nSieveExtensions;
static const unsigned int nMaxSieveFilterPrimes = 78498u; // size of prime table
static const unsigned int nDefaultSieveFilterPrimes = 14000u;
static const unsigned int nMinSieveFilterPrimes = 1000u;
extern unsigned int nSieveFilterPrimes;
static const unsigned int nMaxSieveSize = 10000000u;
static const unsigned int nDefaultSieveSize = 1376256u;
static const unsigned int nMinSieveSize = 100000u;
extern unsigned int nSieveSize;
static const unsigned int nMaxL1CacheSize = 128000u;
static const unsigned int nDefaultL1CacheSize = 28672u;
static const unsigned int nMinL1CacheSize = 12000u;
extern unsigned int nL1CacheSize;
static const uint256 hashBlockHeaderLimit = (uint256(1) << 255);
static const CBigNum bnOne = 1;
static const CBigNum bnPrimeMax = (bnOne << 2000) - 1;
static const CBigNum bnPrimeMin = (bnOne << 255);
static const mpz_class mpzOne = 1;
static const mpz_class mpzTwo = 2;
static const mpz_class mpzPrimeMax = (mpzOne << 2000) - 1;
static const mpz_class mpzPrimeMin = (mpzOne << 255);
static const unsigned int nPrimorialHashFactor = 7;
static const unsigned int nInitialPrimorialMultiplier = 47;
static const unsigned int nInitialPrimorialMultiplierTestnet = 17;

extern unsigned int nTargetInitialLength;
extern unsigned int nTargetMinLength;

// Test probable prime chain for: bnPrimeChainOrigin
// fFermatTest
//   true - Use only Fermat tests
//   false - Use Fermat-Euler-Lagrange-Lifchitz tests
// Return value:
//   true - Probable prime chain found (one of nChainLength meeting target)
//   false - prime chain too short (none of nChainLength meeting target)
bool ProbablePrimeChainTest(const CBigNum& bnPrimeChainOrigin, unsigned int nBits, bool fFermatTest, unsigned int& nChainLengthCunningham1, unsigned int& nChainLengthCunningham2, unsigned int& nChainLengthBiTwin);

static const unsigned int nFractionalBits = 24;
static const unsigned int TARGET_FRACTIONAL_MASK = (1u<<nFractionalBits) - 1;
static const unsigned int TARGET_LENGTH_MASK = ~TARGET_FRACTIONAL_MASK;
static const uint64 nFractionalDifficultyMax = (1llu << (nFractionalBits + 32));
static const uint64 nFractionalDifficultyMin = (1llu << 32);
static const uint64 nFractionalDifficultyThreshold = (1llu << (8 + 32));
static const unsigned int nWorkTransitionRatio = 32;
static const unsigned int nWorkTransitionRatioLog = 5; // log_2(32) = 5
unsigned int TargetGetLimit();
unsigned int TargetGetInitial();
unsigned int TargetGetLength(unsigned int nBits);
bool TargetSetLength(unsigned int nLength, unsigned int& nBits);
unsigned int TargetGetFractional(unsigned int nBits);
uint64 TargetGetFractionalDifficulty(unsigned int nBits);
bool TargetSetFractionalDifficulty(uint64 nFractionalDifficulty, unsigned int& nBits);
std::string TargetToString(unsigned int nBits);
unsigned int TargetFromInt(unsigned int nLength);
bool TargetGetMint(unsigned int nBits, uint64& nMint);
bool TargetGetNext(unsigned int nBits, int64 nInterval, int64 nTargetSpacing, int64 nActualSpacing, unsigned int& nBitsNext);

// Check prime proof-of-work
enum // prime chain type
{
    PRIME_CHAIN_CUNNINGHAM1 = 1u,
    PRIME_CHAIN_CUNNINGHAM2 = 2u,
    PRIME_CHAIN_BI_TWIN     = 3u,
};
bool CheckPrimeProofOfWork(uint256 hashBlockHeader, unsigned int nBits, const CBigNum& bnPrimeChainMultiplier, unsigned int& nChainType, unsigned int& nChainLength);

// Estimate work transition target to longer prime chain
unsigned int EstimateWorkTransition(unsigned int nPrevWorkTransition, unsigned int nBits, unsigned int nChainLength);
// prime chain type and length value
std::string GetPrimeChainName(unsigned int nChainType, unsigned int nChainLength);

#endif // __PRIME_H__
