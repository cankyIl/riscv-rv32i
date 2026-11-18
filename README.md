# riscv-rv32i

An RV32I RISC-V CPU written in SystemVerilog, built up component by component while
reading *Digital Design and Computer Architecture, RISC-V Edition* (Harris & Harris).

Roadmap:

1. **Building blocks** (Ch. 5): adders, ALU, shifters, registers, memories
2. **Single-cycle RV32I core** (Ch. 7), then multicycle and pipelined versions
3. **FPGA bring-up**: board not chosen yet, so the RTL is kept vendor-neutral
4. **Research**: custom instructions and other extensions

See [docs/roadmap.md](docs/roadmap.md) for the detailed checklist.

## Layout

```
rtl/common/   generic building blocks (adders, muxes, ...)
rtl/core/     CPU-specific blocks (ALU, register file, decoder, datapath, ...)
tb/           self-checking testbenches, one per module: tb_<module>.sv
sim/out/      simulation output: logs and .vcd waveforms (git-ignored)
docs/         setup guide, roadmap, design notes
```

## Quick start

Set up the tools first: [docs/windows-setup.md](docs/windows-setup.md).

```sh
make test                 # run all testbenches with Icarus Verilog
make test SIM=verilator   # same, with Verilator
make sim  TB=tb_<name>    # run one testbench
make wave TB=tb_<name>    # run it and open the waveform in GTKWave
make lint                 # Verilator lint of all RTL
```

Each testbench should print `PASS: <name>` or `FAIL: ...`, because `make test` treats any
`FAIL` in the output as a failure. GitHub Actions runs the same flow on every push.

## Adding a new component

1. Write `rtl/common/<name>.sv` (or `rtl/core/`), one module per file, file name = module name.
2. Write `tb/tb_<name>.sv`: drive inputs, compare to a reference, print `PASS`/`FAIL`, dump a VCD to `sim/out/`.
3. `make sim TB=tb_<name>`, then `make test` before committing.

## Conventions

- SystemVerilog-2012 subset supported by both Icarus 12 and Verilator 5.
- `logic` everywhere, `always_comb` / `always_ff`, parameterised widths (`N`/`WIDTH`).
- No vendor primitives in `rtl/`; FPGA-specific wrappers will live in `fpga/<board>/` later.
