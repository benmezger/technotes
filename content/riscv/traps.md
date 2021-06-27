---
title: Traps
description: Notes on RISC-V traps
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

## Traps {#traps}

Trap refers to the synchronous transfer control to a trap handler caused by an
exceptional condition occurring within a RISC thread. Trap handlers normally
execute in a more privilege environment.

## The Machine trap vector base-address register (`mtvec`) {#the-machine-trap-vector-base-address-register--mtvec}

When something happens in RISCV, the CPU calls the function stored in `mtvec`.
`mtvec` is a XLEN (32-64bit wide) read/write register that holds a **trap vector
configuration** which consists of the base address (the function address) and the
vector mode.

RISCV requires `mtvec` to be always implemented, but can contain a hardwired to
a read-only value. The base field must always be aligned on a 4-byte boundary
however, mode settings may impose additional base field alignment constraints.

We can visualize this as an array for XLEN bits:

```C
/* xlen is 32-bits ie. (int32_t) or 64-bits ie. (int64_t) */
xlen mtvec[xlen];
xlen base = mtvec[xlen-2];
xlen mode = mtvec[2];
```

If mode gets set to `DIRECT MODE`, it means all traps will go to the exact same
function, if `VECTOR mode` is set, all synchronous exceptions into machine mode
cause the `PC` to be set to the address of the base field, whereas interrupts
will set `PC` to `base + 4 * cause`. For example Table [1](#table--tbl:exception-codes) has
machine-mode timer interrupt code `7` causes the PC to be set to BASE + 0x1c
(BASE + 4 \* 7).

<a id="table--tbl:exception-codes"></a>

| Interrupt[^fn:1] | Exception code | Reason                         |
| ---------------- | -------------- | ------------------------------ |
| 1                | 0              | User software interrupt        |
| 1                | 1              | Supervisor software interrupt  |
| 1                | 2              | _Reserved_                     |
| 1                | 3              | Machine software interrupt     |
| 1                | 4              | User timer interrupt           |
| 1                | 5              | Supervisor timer interrupt     |
| 1                | 6              | _Reserved_                     |
| 1                | 7              | Machine timer interrupt        |
| 1                | 8              | User external interrupt        |
| 1                | 9              | Supervisor external interrupt  |
| 1                | 10             | _Reserved_                     |
| 1                | 11             | Machine external interrupt     |
| 1                | >= 12          | _Reserved_                     |
| 0                | 0              | Instruction address misaligned |
| 0                | 1              | Instruction access fault       |
| 0                | 2              | Illegal instruction            |
| 0                | 3              | Breakpoint                     |
| 0                | 4              | Load address misaligned        |
| 0                | 5              | Load access fault              |
| 0                | 6              | Store/AMO address misaligned   |
| 0                | 7              | Store/AMO access fault         |
| 0                | 8              | Environment call from U-mode   |
| 0                | 9              | Environment call from S-mode   |
| 0                | 10             | _Reserved_                     |
| 0                | 11             | Environment call from M-mode   |
| 0                | 12             | Instruction page fault         |
| 0                | 13             | Load page fault                |
| 0                | 14             | _Reserved_                     |
| 0                | 15             | Store/AMO page fault           |
| 0                | >= 16          | _Reserved_                     |

[^fn:1]: `0` for asynchronous and `1` for synchronous
