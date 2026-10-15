# Neon_Reduce 课堂作业

这是一个用于学习 AArch64 汇编和模运算的课堂作业。

代码演示所列模数的 Barrett/Montgomery reduction 接口，以及对应的 AArch64 NEON 汇编实现。

这里实现的是不同商密算法共用的底层模约减组件，不是这些商密算法本身的完整实现。BW-KEM/AFS-KEX、DTRU 和 OPS Digital Signature Algorithm 仍然是不同的上层算法；它们可以调用相同的 Barrett 或 Montgomery reduction，但各自的多项式运算、采样、编码、密钥流程和签名流程并不相同。

## NEON 四通道接口

`neon_barrett_u32x4` 和 `neon_montgomery_u32x4` 的对外接口都是四通道：一次处理四个 `uint32_t` 输入，使用 `v.4s` 表示 `{x0,x1,x2,x3}`。

Montgomery 的对外输入仍是四个 `uint64_t`。由于一个 NEON `v.2d` 寄存器只能容纳两个 64 位通道，汇编会把输入分成两组 `v.2d` 依次处理，再合并为四个输出。

当前向量版本面向 `q = 769/2017/3329/3457`；其 Barrett 输入须满足每个 `x < q²`，Montgomery 输入满足 `t < q·2³²`。`mu` 使用 `floor(2³²/q)`。16776961 和 67104769 尚未纳入此向量接口。

使用 AArch64 工具链编译：`-Iinclude src/neon_vector_reduce.S`。
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

## 大模数路径

`q' = 16776961` 和 `q = 67104769` 的完整参考实现使用 `src/large_mod_reduce.S` 中的 AArch64 64 位标量 Barrett/Montgomery 入口。当前四通道 32 位 Barrett 路径要求 `x < q² < 2³²`，不适用于这两个大模数；同时，NEON 没有单条 64×64→128 乘法指令，所以大模数的 NEON 分片版本单独列为实验代码。四个小模数仍使用 `src/neon_vector_reduce.S`。

另有 `src/neon_barrett_u64x2_experimental.S`：它用两个 32 位部分积展示两路 64 位乘法的 NEON 拆分方式。该文件明确是 **EXPERIMENTAL**，当前只展示部分积和高位近似，未完成进位闭合，也未在 AArch64 真机验证，不能替代 `large_mod_reduce.S` 的标量参考实现。

## 文件说明

| 文件 | 作用 | 状态 |
| --- | --- | --- |
| `include/neon_vector_reduce.h` | 四通道 NEON 函数声明 | 对应头文件 |
| `src/neon_vector_reduce.S` | 四个 `uint32_t` 通道的小模数 NEON Barrett/Montgomery reduction | NEON 实现，未在当前 x86_64 环境运行 |
| `include/large_mod_reduce.h` | 标量参考函数声明 | 对应头文件 |
| `src/large_mod_reduce.S` | 大模数的 64 位标量 Barrett/Montgomery 参考实现 | 完整参考路径 |
| `include/neon_experimental.h` | NEON 实验函数声明 | 实验接口 |
| `src/neon_barrett_u64x2_experimental.S` | 用 32 位部分积模拟 64 位乘法的 NEON 实验 | 未完成进位闭合，未验证 |
