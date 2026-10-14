# Neon_Reduce 课堂作业

这是一个用于学习 AArch64 汇编和模运算的课堂作业。

代码演示所列模数的 Barrett/Montgomery reduction 接口，以及对应的 AArch64 汇编实现。

`neon_barrett_u32` accepts `x < q²` and `mu=floor(2^64/q)`.  
`neon_montgomery_u32` accepts `t < q·2^32` and `qinv=-q⁻¹ (mod 2^32)`.

使用 AArch64 工具链编译：`-Iinclude src/neon_reduce.S src/neon_moduli.c`。
当前 x86_64 环境不能执行这些指令，因此这里只进行源码和接口层面的整理；后续应在 AArch64/NEON 设备上验证。
