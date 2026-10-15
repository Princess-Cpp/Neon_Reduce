# Neon_Reduce 课堂作业

这是一个用于学习 AArch64 汇编和模运算的课堂作业。

代码演示所列模数的 Barrett/Montgomery reduction 接口，以及对应的 AArch64 NEON 汇编实现。

## NEON 四通道接口

`neon_barrett_u32x4` 和 `neon_montgomery_u32x4` 的对外接口都是四通道：一次处理四个 `uint32_t` 输入，使用 `v.4s` 表示 `{x0,x1,x2,x3}`。

Montgomery 的输入是四个 `uint64_t`。由于一个 NEON `v.2d` 只有两个 64 位通道，汇编内部会把这四个 64 位值分成两组 `v.2d` 处理，再合并为四个输出；这里的“二通道”指 64 位中间量的内部布局，不是另一个二通道 API。

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

`q' = 16776961` 和 `q = 67104769` 使用 `src/large_mod_reduce.S` 中的 AArch64 64 位标量 Barrett/Montgomery 入口。NEON 没有单条 64×64→128 乘法指令，因此这两个模数不使用当前四通道 32 位 Barrett 路径；四个小模数仍使用 `src/neon_vector_reduce.S`。
