# RV32I build / test flow
#
#   make test               run every testbench (default simulator: Icarus)
#   make test SIM=verilator run every testbench with Verilator
#   make sim TB=tb_foo      run one testbench
#   make wave TB=tb_foo     run one testbench and open the waveform in GTKWave
#   make lint               lint all RTL with Verilator
#   make clean

SIM     ?= icarus
TB      ?=
OUT     := sim/out

RTL     := $(sort $(wildcard rtl/*/*.sv))
TBS     := $(basename $(notdir $(wildcard tb/tb_*.sv)))

IVERILOG ?= iverilog
VVP      ?= vvp
VERILATOR ?= verilator
GTKWAVE  ?= gtkwave

.PHONY: test sim wave lint clean list

list:
	@echo "Testbenches: $(TBS)"

test:
	@if [ -z "$(TBS)" ]; then echo "No testbenches in tb/ yet."; exit 0; fi; \
	fail=0; \
	for t in $(TBS); do \
	  $(MAKE) --no-print-directory sim TB=$$t SIM=$(SIM) || fail=1; \
	done; \
	if [ $$fail -eq 0 ]; then echo "== ALL TESTS PASSED =="; else echo "== SOME TESTS FAILED =="; exit 1; fi

sim: $(OUT)
	@if [ -z "$(TB)" ]; then echo "Usage: make sim TB=tb_<name>"; exit 1; fi
ifeq ($(SIM),icarus)
	@$(IVERILOG) -g2012 -Wall -o $(OUT)/$(TB).vvp -s $(TB) $(RTL) tb/$(TB).sv
	@$(VVP) -n $(OUT)/$(TB).vvp | tee $(OUT)/$(TB).log
else ifeq ($(SIM),verilator)
	@$(VERILATOR) --binary --timing -Wall -Wno-fatal --trace -j 0 \
	  --top-module $(TB) -Mdir $(OUT)/obj_$(TB) $(RTL) tb/$(TB).sv >/dev/null
	@$(OUT)/obj_$(TB)/V$(TB) | tee $(OUT)/$(TB).log
else
	$(error Unknown SIM=$(SIM), use icarus or verilator)
endif
	@! grep -q "FAIL" $(OUT)/$(TB).log

wave: sim
	$(GTKWAVE) $(OUT)/$(TB).vcd &

# Lints with each RTL file as top in turn (file name = module name)
lint:
	@if [ -z "$(RTL)" ]; then echo "No RTL in rtl/ yet."; exit 0; fi; \
	for f in $(RTL); do \
	  $(VERILATOR) --lint-only -Wall $(RTL) --top-module $$(basename $$f .sv) || exit 1; \
	done; echo "Lint clean."

$(OUT):
	@mkdir -p $(OUT)

clean:
	rm -rf $(OUT)
