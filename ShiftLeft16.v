module ShiftLeft16(
  input  wire [31:0] imediato,

  output reg [31:0] saidaShiftLeft16
);
  always @(imediato) begin
    saidaShiftLeft16 = imediato << 16;
  end
endmodule
