.text
.arch armv8-a
.align 2
.global neon_barrett_u32
.type neon_barrett_u32,%function
/* uint32_t neon_barrett_u32(uint64_t x, uint32_t q, uint64_t mu)
 * q in w1, mu in x2. This uses qhat=floor(x*mu/2^64), then two
 * constant-time subtracts. The caller must keep x < q^2. */
neon_barrett_u32:
    mul     x3, x0, x2
    umulh   x4, x0, x2
    /* qhat is x4; compute r=x-qhat*q */
    madd    x5, x4, x1, xzr
    sub     x5, x0, x5
    cmp     x5, x1
    csel    x5, x5, x5, lo
    sub     x6, x5, x1
    csel    x5, x6, x5, hs
    cmp     x5, x1
    sub     x6, x5, x1
    csel    w0, w6, w5, hs
    ret
.size neon_barrett_u32, .-neon_barrett_u32

.align 2
.global neon_montgomery_u32
.type neon_montgomery_u32,%function
/* uint32_t neon_montgomery_u32(uint64_t t, uint32_t q, uint32_t qinv)
 * Computes t*R^-1 mod q, R=2^32, for t < q*R. */
neon_montgomery_u32:
    mul     w3, w0, w2
    umaddl  x4, w3, w1, x0
    lsr     x4, x4, #32
    sub     x5, x4, x1
    cmp     x4, x1
    csel    w0, w5, w4, hs
    ret
.size neon_montgomery_u32, .-neon_montgomery_u32
