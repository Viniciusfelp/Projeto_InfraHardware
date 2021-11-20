module MuxEscritaEnderecoReg (
  input  wire [1:0]     RegWriteMUX,
  input  wire [4:0]     valorInstrucao16to20,
  input  wire [15:0]    valorInstrucao0to15,

  output reg [4:0] saidaValorEnderecoReg
);
  parameter valor29 = 32'b00000000000000000000000000011101; // 29 em decimal
  parameter valor31 = 32'b00000000000000000000000000011111; // 31 em decimal

  always @(*) begin
    saidaValorEnderecoReg = ((RegWriteMUX[1])
      ? ((RegWriteMUX[0]) ? valorInstrucao0to15[15:11] : valor31)
      : ((RegWriteMUX[0]) ? valor29 : valorInstrucao16to20)
    );
  end
endmodule

// 00 => intrução[20:16]
// 01 => 29
// 10 => 31
// 11 => intrução[15:11]