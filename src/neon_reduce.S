.text
.arch armv8-a
.align 2
.global neon_barrett_u32
.type neon_barrett_u32,%function
/*
 * uint32_t neon_barrett_u32(uint64_t x, uint32_t q, uint64_t mu)
 *
 * AArch64 PCS arguments: x0=x, w1=q, x2=mu.  mu is floor(2^64/q).
 * umulh gives qhat=floor(x*mu/2^64); the remainder is then corrected
 * with at most two branch-free subtracts.  The caller must guarantee
 * 0 <= x < q^2 and q < 2^32. x3 is deliberately unused after mul,
 * but keeps the low product available for single-step instrumentation.
 */
neon_barrett_u32:
    mul     x3, x0, x2
    umulh   x4, x0, x2
    /* qhat is x4; compute r=x-qhat*q. */
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
/*
 * uint32_t neon_montgomery_u32(uint64_t t, uint32_t q, uint32_t qinv)
 *
 * Arguments: x0=t, w1=q, w2=qinv where qinv=-q^(-1) mod 2^32.
 * Let m=(t mod 2^32)*qinv mod 2^32.  The low word of t+m*q is zero,
 * so shifting that sum by 32 performs division by R=2^32.  One final
 * conditional subtraction puts the result in [0,q). The input bound is
 * 0 <= t < q*R; q must be odd and smaller than R.
 */
neon_montgomery_u32:
    mul     w3, w0, w2
    umaddl  x4, w3, w1, x0
    lsr     x4, x4, #32
    sub     x5, x4, x1
    cmp     x4, x1
    csel    w0, w5, w4, hs
    ret
.size neon_montgomery_u32, .-neon_montgomery_u32
