module MuxDivB (
  input wire DIVB,
  input wire [31:0] MEM_to_IR,
  input wire [31:0] RegB_out,
  output reg [31:0] MuxDivB_out
);

  always @(*) begin
    MuxDivB_out = (DIVB ? RegB_out : MEM_to_IR);
  end
endmodule

// 0 => MEM_to_IR
// 1 => RegB_out