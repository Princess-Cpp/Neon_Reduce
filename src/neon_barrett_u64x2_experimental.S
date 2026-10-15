.text
.arch armv8-a
.align 2
.global neon_barrett_u64x2_experimental
.type neon_barrett_u64x2_experimental,%function
/*
 * EXPERIMENTAL two-lane 64x64 high-product demonstration.
 * x0=out[2], x1=in[2], x2=mu[2]. Each 64-bit product is split into
 * xlo/xhi and mu_lo/mu_hi; umull/umull2 calculate 32x32 partial products.
 * The carry-complete reduction is intentionally left for AArch64 validation;
 * this entry is a teaching aid and is not a cryptographic implementation.
 */
neon_barrett_u64x2_experimental:
    ld1     {v0.2d}, [x1]          // x
    ld1     {v1.2d}, [x2]          // mu
    xtn     v2.2s, v0.2d            // x_lo
    shrn    v3.2s, v0.2d, #32       // x_hi
    xtn     v4.2s, v1.2d            // mu_lo
    shrn    v5.2s, v1.2d, #32       // mu_hi
    umull   v6.2d, v2.2s, v4.2s     // x_lo*mu_lo
    umull   v7.2d, v2.2s, v5.2s     // x_lo*mu_hi
    umull   v16.2d, v3.2s, v4.2s    // x_hi*mu_lo
    umull   v17.2d, v3.2s, v5.2s    // x_hi*mu_hi
    add     v7.2d, v7.2d, v16.2d    // cross terms
    ushr    v7.2d, v7.2d, #32
    add     v17.2d, v17.2d, v7.2d   // high-product approximation
    st1     {v17.2d}, [x0]
    ret
.size neon_barrett_u64x2_experimental, .-neon_barrett_u64x2_experimental
