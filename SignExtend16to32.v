module SignExtend16to32(
  input wire [15:0] inst15_0,

  output reg [31:0] saida
);
  always @(*) begin
    saida = (inst15_0[15] == 0) ? (32'b00000000000000000000000000000000 + inst15_0) : (32'b11111111111111110000000000000000 + inst15_0);
  end
endmodule