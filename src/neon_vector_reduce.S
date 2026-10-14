.text
.arch armv8-a
.align 2
.global neon_barrett_u32x4
.type neon_barrett_u32x4,%function
/* x0=out, x1=in, w2=q, w3=mu=floor(2^32/q); in < q^2. */
neon_barrett_u32x4:
    ld1     {v0.4s}, [x1]
    dup     v1.4s, w3
    dup     v2.4s, w2
    umull   v3.2d, v0.2s, v1.2s
    umull2  v4.2d, v0.4s, v1.4s
    ushr    v3.2d, v3.2d, #32
    ushr    v4.2d, v4.2d, #32
    xtn     v5.2s, v3.2d
    xtn2    v5.4s, v4.2d
    mul     v6.4s, v5.4s, v2.4s
    sub     v0.4s, v0.4s, v6.4s
    cmhs    v7.4s, v0.4s, v2.4s
    sub     v6.4s, v0.4s, v2.4s
    bsl     v7.16b, v6.16b, v0.16b
    cmhs    v7.4s, v6.4s, v2.4s
    sub     v0.4s, v6.4s, v2.4s
    bsl     v7.16b, v0.16b, v6.16b
    st1     {v6.4s}, [x0]
    ret
.size neon_barrett_u32x4, .-neon_barrett_u32x4

.align 2
.global neon_montgomery_u32x4
.type neon_montgomery_u32x4,%function
/* x0=out, x1=t[4], w2=q, w3=qinv=-q^-1 mod 2^32. */
neon_montgomery_u32x4:
    ld1     {v0.2d, v1.2d}, [x1]
    dup     v2.4s, w2
    dup     v3.4s, w3
    uzp1    v4.4s, v0.4s, v1.4s
    mul     v4.4s, v4.4s, v3.4s
    umull   v5.2d, v4.2s, v2.2s
    umull2  v6.2d, v4.4s, v2.4s
    add     v0.2d, v0.2d, v5.2d
    add     v1.2d, v1.2d, v6.2d
    ushr    v0.2d, v0.2d, #32
    ushr    v1.2d, v1.2d, #32
    uzp1    v4.4s, v0.4s, v1.4s
    cmhs    v5.4s, v4.4s, v2.4s
    sub     v6.4s, v4.4s, v2.4s
    bsl     v5.16b, v6.16b, v4.16b
    st1     {v5.4s}, [x0]
    ret
.size neon_montgomery_u32x4, .-neon_montgomery_u32x4
