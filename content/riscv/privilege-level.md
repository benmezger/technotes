---
title: Privileve level
description: Notes on RISC-V privilege-level
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

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
