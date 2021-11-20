module ShiftLeft2_26to28(
  input wire [4:0] inst25_21,
  input wire [4:0] inst20_16,
  input wire [15:0] inst15_0,
  output reg [27:0] saida
);
  reg [25:0] inst25_0;
  
  always @(*) begin
    inst25_0 = {inst25_21,inst20_16,inst15_0};
    saida = ((inst25_0[25] == 0)
      ? (28'b0000000000000000000000000000 + inst25_0)
      : (28'b1100000000000000000000000000 + inst25_0));
  end
endmodule