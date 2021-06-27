---
title: Interrupts
description: Notes on RISC-V interrupts
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

See [traps](/riscv/traps) for interrupt codes.

## Interrupts {#interrupts}

Interrupt refers to an external event that occurs asynchronously to the current
RISCV thread. When an interrupt occurs, some instruction gets selected to
receive an interrupt exception and subsequently experiences a trap.
