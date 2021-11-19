module MuxUlaB (
  input  wire [1:0]  seletorMuxUlaB,
  input  wire [31:0] valorSaidaRegB,
  input  wire [31:0] valorSaidaSignExtend16to32,
  input  wire [31:0] valorSaidaShiftLeft2,

  output reg [31:0] saidaBparaUla
);
  parameter valorParaPcMais4 = 32'b00000000000000000000000000000100; // 4 em decimal

  always @(*) begin
    saidaBparaUla = ((seletorMuxUlaB[1])
      ? ((seletorMuxUlaB[0]) ? valorSaidaShiftLeft2 : valorSaidaSignExtend16to32)
      : ((seletorMuxUlaB[0]) ? valorParaPcMais4 : valorSaidaRegB)
    );
  end
endmodule

// 00 => valorSaidaRegB
// 01 => 4
// 10 => valorSaidaSignExtend16to32
// 11 => valorSaidaShiftLeft2