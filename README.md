# Neon_Reduce 课堂作业

这是一个用于学习 AArch64 汇编和模运算的课堂作业。

代码演示所列模数的 Barrett/Montgomery reduction 接口，以及对应的 AArch64 汇编实现。

`barrett_u32_64mu` accepts `x < q²` and `mu=floor(2^64/q)`.
`montgomery_u32` accepts `t < q·2^32`, odd `q < 2^31`, and `qinv=-q⁻¹ (mod 2^32)`.

这两个入口使用 AArch64 通用寄存器中的标量整数指令，不是 NEON 向量实现；函数名因此不再使用 `neon_` 前缀。

## NEON 四通道接口

`neon_barrett_u32x4` 和 `neon_montgomery_u32x4` 使用 `v0`–`v6` 处理四个 `uint32_t` 通道。当前向量版本面向 `q = 769/2017/3329/3457`；其 Barrett 输入须满足每个 `x < q²`，Montgomery 输入为四个 `uint64_t` 且满足 `t < q·2³²`。`mu` 使用 `floor(2³²/q)`。16776961 和 67104769 尚未纳入此向量接口。

使用 AArch64 工具链编译：`-Iinclude src/neon_reduce.S src/neon_moduli.c`。
当前 x86_64 环境不能执行这些指令，因此这里只进行源码和接口层面的整理；后续应在 AArch64/NEON 设备上验证。

## 算法与模数

本作业覆盖以下算法参数：

| 算法 | 模数 |
| --- | ---: |
| BW-KEM / AFS-KEX | `q = 3329` |
| DTRU（三项分圆环） | `q = 3457` |
| DTRU（二次幂） | `q = 769` |
| DTRU（prime） | `q = 2017`，`q' = 16776961` |
| OPS Digital Signature Algorithm | `q = 67104769` |
