#pragma once
#include <stdint.h>

/* EXPERIMENTAL: two-lane 64-bit Barrett high-product approximation.
 * Not validated on AArch64 hardware; use large_mod_reduce.S as reference. */
void neon_barrett_u64x2_experimental(uint64_t out[2], const uint64_t in[2],
                                     const uint64_t mu[2]);
