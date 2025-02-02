SRC=src/top.sv src/cpu.sv src/ram.sv
TEST=src/tb_cpu.sv

TESTMAIN_TB=tests/tb_main.cpp
TESTMAIN_WAVE=tests/wave_main.cpp

TESTBIN=Vtb_cpu
ifneq ($(TB), 1)
	TESTBIN:=Vtop
endif
TESTMAK=$(TESTBIN).mk

.PHONY: testbin generate clean run wave


testbin: generate
	make -j -C obj_dir -f $(TESTMAK) $(TESTBIN)

generate: $(TESTMAIN_TB) $(TESTMAIN_WAVE)
	@if [ "$(TB)" = "1" ]; then \
		verilator --cc $(TEST) $(SRC) --assert --timing --exe --build $(TESTMAIN_TB) --top-module tb_cpu -DDEBUG_MODE; \
	else \
		verilator -Wall --trace -cc $(SRC) --exe --build $(TESTMAIN_WAVE) --top-module top; \
	fi

clean:
	rm -rf obj_dir waveform.vcd

run: testbin
	./obj_dir/$(TESTBIN)

wave: run
	gtkwave ./waveform.vcd


