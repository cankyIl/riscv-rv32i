# Roadmap

Tick items off as they land. Section numbers refer to Harris & Harris, RISC-V Edition.

## Chapter 5: Digital building blocks
- [ ] Full adder, ripple-carry adder (5.2.1)
- [ ] Carry-lookahead / prefix adder (5.2.1)
- [ ] Comparators (5.2.3)
- [ ] ALU: add, sub, and, or, slt with ZNCV flags (5.2.4)
- [ ] Shifters (5.2.5)
- [ ] Counters, shift registers (5.4)
- [ ] Register file, RAM, ROM (5.5)

## Chapter 6: Architecture
- [ ] Write a few RV32I assembly test programs
- [ ] Set up a RISC-V GCC toolchain to assemble them into hex files

## Chapter 7: Microarchitecture
- [ ] Extend the ALU to the full RV32I set (xor, sll, srl, sra, sltu)
- [ ] Immediate extend, control unit / decoder
- [ ] Single-cycle RV32I core + program tests
- [ ] Multicycle core
- [ ] Pipelined core with hazard unit
- [ ] riscv-tests / riscv-arch-test compliance

## FPGA
- [ ] Choose a board
- [ ] Top-level wrapper, clock/reset, LEDs/UART
- [ ] Synthesis flow (vendor tool or Yosys/nextpnr)

## Research
- [ ] Custom instruction(s) in the custom-0 opcode space
