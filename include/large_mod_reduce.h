#pragma once
#include <stdint.h>
/* Scalar AArch64 fallback for moduli whose square exceeds 32 bits. */
uint32_t barrett_u32_64mu(uint64_t x, uint32_t q, uint64_t mu);
uint32_t montgomery_u32(uint64_t t, uint32_t q, uint32_t qinv);
