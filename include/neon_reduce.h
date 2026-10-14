#pragma once
#include <stdint.h>

/* AArch64-only reduction primitives. No runtime, heap, or scalar fallback
 * is required. Callers must satisfy the bounds documented below. */
/* Barrett: returns x mod q for 0 <= x < q^2, mu=floor(2^64/q). */
uint32_t neon_barrett_u32(uint64_t x, uint32_t q, uint64_t mu);
uint32_t neon_montgomery_u32(uint64_t t, uint32_t q, uint32_t qinv);

/* Per-modulus constants: mu=floor(2^64/q), qinv=-q^{-1} mod 2^32. */
struct neon_modulus { uint32_t q, qinv; uint64_t mu; };
extern const struct neon_modulus neon_moduli[];
enum neon_modulus_id { NEON_BW_KEM, NEON_DTRU_3457, NEON_DTRU_769,
                       NEON_DTRU_2017, NEON_DTRU_16776961, NEON_OPS_67104769 };
