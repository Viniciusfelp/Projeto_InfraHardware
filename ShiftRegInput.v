  module ShiftRegInput (
  input  wire        seletorShiftRegA,
  input  wire [31:0] valorRegA,
  input  wire [31:0] valorRegB,

  output reg [31:0] saidaShiftRegA
);
  always @(*) begin
    saidaShiftRegA = (seletorShiftRegA) ? valorRegB : valorRegA;
  end
endmodule

// 0 => valorRegA
// 1 => valorRegB
