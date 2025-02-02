module ram(
  input  logic        clk,
  input  logic        we,
  input  logic [7:0]  r_addr,
  output logic [7:0]  r_data,
  input  logic [7:0]  w_addr,
  input  logic [7:0]  w_data
);

  // 8bit x 16 words memory space
  logic [7:0] mem [255:0];

  initial begin
    mem[0] = 8'b01100_110;// inc R6
    mem[1] = 8'b1001_0000;// jmp 0
  end

  // write (sync clock)
  always_ff @(posedge clk) begin
    if (we) begin
      mem[w_addr] <= w_data;
    end
  end

  // read
  assign r_data = mem[r_addr];

endmodule

