SRC=src/top.sv src/cpu.sv src/ram.sv
TEST=src/tb_cpu.sv

TESTMAIN_TB=tests/tb_main.cpp
TESTBIN=Vtb_cpu

.PHONY: testbin generate clean run wave


testbin: generate

generate: $(TESTMAIN_TB)
	verilator --trace --cc $(TEST) $(SRC) --assert --timing --exe --build $(TESTMAIN_TB) --top-module tb_cpu -DDEBUG_MODE

clean:
	rm -rf obj_dir waveform.vcd

run: testbin
	./obj_dir/$(TESTBIN)

wave: run
	gtkwave ./waveform.vcd


