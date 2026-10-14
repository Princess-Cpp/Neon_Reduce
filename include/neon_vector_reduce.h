#pragma once
#include <stdint.h>

/* AArch64 NEON, four lanes. q must be one of 769, 2017, 3329, 3457. */
void neon_barrett_u32x4(uint32_t out[4], const uint32_t in[4],
                        uint32_t q, uint32_t mu);
/* t[4] contains 64-bit Montgomery numerators, with t < q*2^32. */
void neon_montgomery_u32x4(uint32_t out[4], const uint64_t t[4],
                           uint32_t q, uint32_t qinv);
