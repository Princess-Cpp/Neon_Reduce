# Neon

AArch64 assembly-only modular reduction primitives for the project moduli.

`neon_barrett_u32` accepts `x < q²` and `mu=floor(2^64/q)`.  
`neon_montgomery_u32` accepts `t < q·2^32` and `qinv=-q⁻¹ (mod 2^32)`.

Build on an AArch64 toolchain with `-Iinclude src/neon_reduce.S src/neon_moduli.c`.
The current x86_64 onboarding machine cannot execute these instructions; test on
an AArch64/NEON runner before release.
