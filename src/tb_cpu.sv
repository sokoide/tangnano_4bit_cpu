module tb_cpu(
  input  logic         clk
);

  // signals for test
  logic reset;
  logic [3:0] btn;
  logic [3:0] led;
  logic [3:0] adr;
  logic [7:0] dout;
  logic [3:0] regs [7:0];

  // ram instance
  logic [7:0] r_data;
  ram ram_inst (
    .clk    (clk),
    .we     (1'b0),
    .r_addr ({4'b0000, adr}),  // receive from CPU
    .r_data (r_data),
    .w_addr (8'd0),
    .w_data (8'd0)
  );

  // DUT (Device Under Test)
  cpu dut (
    .reset  (reset),
    .clk    (clk),
    .btn    (btn),
    .led    (led),
    .adr    (adr),
    .dout   (r_data)
`ifdef DEBUG_MODE
    , .debug_regs(regs)
`endif
  );

  // Test
  initial begin
    btn = 4'b0000;

    reset = 0; // active
    repeat (10) @(posedge clk);  // wait for 10 clock cycles
    reset = 1; // release

    // afetr 10 cycles (reset), adr must be 0
    // test led
    if (led !== 4'b0000) begin
      $display("ERROR: Unexpected led value: %b", led);
      $stop;
    end
    // test regs
    if (regs[0] !== 4'b0000) begin
      $display("ERROR: Unexpected regs[0] value: %b", regs[0]);
      $stop;
    end
    if (regs[6] !== 4'b0000) begin
      $display("ERROR: Unexpected regs[6] value: %b", regs[6]);
      $stop;
    end

    // after 11 cycles
    repeat (1) @(posedge clk);
    if (led !== 4'b0001) begin
      $display("ERROR: Unexpected led value: %b", led);
      $stop;
    end
    // test regs
    if (regs[6] !== 4'b0001) begin
      $display("ERROR: Unexpected regs[6] value: %b", regs[6]);
      $stop;
    end

    // after 15 cycles
    repeat (4) @(posedge clk);
    // test regs
    if (regs[6] !== 4'b0011) begin
      $display("ERROR: Unexpected regs[6] value: %b", regs[6]);
      $stop;
    end

    // after 17 cycles
    repeat (2) @(posedge clk);
    // test regs
    if (regs[6] !== 4'b0100) begin
      $display("ERROR: Unexpected regs[6] value: %b", regs[6]);
      $stop;
    end

    // get traces some more in the vcd
    repeat (100) @(posedge clk);

    $display("All Test Passed");
    $finish;
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, cpu_tb);
  end

endmodule

