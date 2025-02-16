// tb_main.cpp
#include "Vtb_cpu.h"   // Top-level module generated by Verilator
#include "verilated.h" // Verilator header
#include <iostream>

// Define a simulation time unit (e.g., 1 time unit per iteration)
vluint64_t main_time = 0; // current simulation time

// Called by $time in your SystemVerilog code if needed.
double sc_time_stamp() { return main_time; }

int main(int argc, char** argv) {
    // Initialize Verilator with command-line arguments.
    Verilated::commandArgs(argc, argv);

    // Call it before `new` to enable wave trace
    Verilated::traceEverOn(true);

    // Create an instance of the top-level module.
    Vtb_cpu* top = new Vtb_cpu;
    top->clk = 1;

    // Run the simulation for a fixed number of time units.
    // Adjust the simulation duration as needed to allow your testbench to
    // complete.
    const vluint64_t sim_end = 100; // simulation end time units

    while (!Verilated::gotFinish() && main_time < sim_end) {
        // while (main_time < sim_end) {
        // Evaluate the model.
        top->eval();

        // Advance simulation time.
        main_time++;

        // (Optional) Insert any clock toggling or other stimulus if required.
        top->clk = !top->clk;
    }

    // Final evaluation.
    top->final();

    // Clean up.
    delete top;

    return 0;
}

