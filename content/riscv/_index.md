---
title: RISC-V
description: RISC-V notes
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

## Understanding RISCV stack pointer {#understanding-riscv-stack-pointer}

- [L06 RISCV Functions(6up).pdf](<https://inst.eecs.berkeley.edu/~cs61c/fa17/lec/06/L06%20RISCV%20Functions%20(6up).pdf>)

## Exceptions {#exceptions}

Exception are unusual condition occurring at run time associated with an
instruction in the current RISCV thread. Exceptions may be converted to traps,
but that all depends on the execution environment.

## Traps {#traps}

Trap refers to the synchronous transfer control to a trap handler caused by an
exceptional condition occurring within a RISC thread. Trap handlers normally
execute in a more privilege environment.

## Interrupts {#interrupts}

Interrupt refers to an external event that occurs asynchronously to the current
RISCV thread. When an interrupt occurs, some instruction gets selected to
receive an interrupt exception and subsequently experiences a trap.

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

## Privilege modes {#privilege-modes}

| Level | Encoding | Name             | Abbreviation |
| ----- | -------- | ---------------- | ------------ |
| 0     | 00       | User/Application | U            |
| 1     | 01       | Supervisor       | S            |
| 2     | 10       | Reserved         |              |
| 3     | 11       | Machine          | M            |

- Provides protection between different components of the software stack
- Any attempts to perform an operation not allowed by the current mode will cause an exception to be raised
- These exceptions will normally cause traps into the underlying execution environment

### Machine mode {#machine-mode}

- Highest privilege
- **Mandatory** privilege level for RISC-V hardware platform
- Trusted code environment
- Low level access to the machine implementation
- Manage secure execution environments
- User mode and supervisor mode are indented for conventional application and operating systems

| Number of levels | Supported modes | Indented Usage              |
| ---------------- | --------------- | --------------------------- |
| 1                | M               | Simple embedded systems     |
| 2                | M, U            | Secure embedded systems     |
| 3                | M, S U          | Unix-like operating systems |

### Exceptions {#exceptions}

- Any attempts to access non-existent CSR, read or write a read-only register raises an **illegal instruction**
- A read/write register might also contain bits that are read-only, in which writes to read-only bits **are ignored**

### Supervisor mode {#supervisor-mode}

<http://www-inst.eecs.berkeley.edu/~cs152/sp12/handouts/riscv-supervisor.pdf>

- **Steps to reproduce the behavior**
  - Switch to machine mode (if not already by default)

[^fn:1]: `0` for asynchronous and `1` for synchronous
