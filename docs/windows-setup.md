# Windows development setup

You need: a SystemVerilog simulator (Icarus Verilog and/or Verilator), GTKWave for
waveforms, `make`, Git, and VS Code. There are two ways to get them on Windows.
**Option A (WSL2) is recommended**: Verilator, `make` and the later RISC-V GCC
toolchain all work best on Linux, and CI runs the same Ubuntu packages.

## Option A: WSL2 + Ubuntu (recommended)

1. Open **PowerShell as Administrator** and run:
   ```powershell
   wsl --install -d Ubuntu-24.04
   ```
   Reboot when asked, then open "Ubuntu" from the Start menu and create a Linux user.

2. Inside Ubuntu, install the tools:
   ```sh
   sudo apt update
   sudo apt install -y git make iverilog verilator gtkwave
   ```
   GTKWave opens as a normal window on Windows 11 (WSLg handles the display).

3. Configure Git and clone the repo **inside the Linux filesystem** (much faster than `/mnt/c`):
   ```sh
   git config --global user.name  "Your Name"
   git config --global user.email "you@example.com"
   mkdir -p ~/work && cd ~/work
   git clone https://github.com/<your-username>/riscv-rv32i.git
   cd riscv-rv32i
   make test
   ```
   It prints `No testbenches in tb/ yet.` until you add your first one.

4. Install **VS Code** on Windows from https://code.visualstudio.com, then from the Ubuntu shell
   in the repo folder run `code .`. It installs the WSL server automatically. Accept the
   recommended extensions prompt (the repo lists them in `.vscode/extensions.json`):
   - **Verilog-HDL/SystemVerilog** (`mshr-h.veriloghdl`): syntax highlighting, and lint-on-save via Verilator
   - **WSL** (`ms-vscode-remote.remote-wsl`)

   Use the VS Code terminal (Ctrl+`) to run `make` commands.

## Option B: Native Windows with OSS CAD Suite

Use this if you can't use WSL.

1. Install **Git for Windows** (https://git-scm.com/download/win). It includes Git Bash.
2. Download the latest **OSS CAD Suite** Windows build (`oss-cad-suite-windows-x64-*.exe`) from
   https://github.com/YosysHQ/oss-cad-suite-build/releases and extract it, e.g. to `C:\oss-cad-suite`.
   It bundles Icarus Verilog, Verilator, GTKWave, Yosys and nextpnr (useful later for FPGAs).
3. Open a terminal with the tools on PATH by running `C:\oss-cad-suite\start.bat`
   (or in Git Bash: `source /c/oss-cad-suite/environment`).
4. `make` is not included. Install it with `winget install ezwinports.make`, then reopen the terminal.
5. Clone and test:
   ```sh
   git clone https://github.com/<your-username>/riscv-rv32i.git
   cd riscv-rv32i
   make test
   ```
6. Install VS Code and the **Verilog-HDL/SystemVerilog** extension as in Option A.

Note: Verilator on native Windows can be slower to build; if `make test SIM=verilator`
gives trouble, stick to the default Icarus flow or switch to WSL.

## Viewing waveforms

```sh
make wave TB=tb_<name>
```
In GTKWave, expand your testbench → `dut` in the left pane, select signals, and click **Append**.
Tip: right-click a bus → *Data Format* → *Hex* or *Signed Decimal*. Save the view with
*File → Write Save File* as `sim/tb_<name>.gtkw` and it will reopen with your signals.

## Later: RISC-V toolchain (Chapter 6+)

When we start running programs on the core you'll want a cross compiler. In WSL:
```sh
sudo apt install -y gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf
```
(It targets RV32I with `-march=rv32i -mabi=ilp32`.)

## FPGA tools

Deferred until a board is chosen. Vendor tools (Vivado for AMD/Xilinx, Quartus for Intel,
Gowin EDA) or the open-source Yosys/nextpnr flow from OSS CAD Suite will plug in under `fpga/`.
