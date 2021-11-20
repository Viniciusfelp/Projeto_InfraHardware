module MuxEscritaEnderecoReg (
  input  wire [1:0]     seletorMuxEscritaEndereco,
  input  wire [4:0]     valorInstrucao16to20,
  input  wire [15:0]    valorInstrucao0to15,

  output reg [4:0] saidaValorEnderecoReg
);
  parameter valor29 = 32'b00000000000000000000000000011101; // 29 em decimal
  parameter valor31 = 32'b00000000000000000000000000011111; // 31 em decimal

  always @(*) begin
    saidaValorEnderecoReg = ((seletorMuxEscritaEndereco[1])
      ? ((seletorMuxEscritaEndereco[0]) ? valor31 : valor29)
      : ((seletorMuxEscritaEndereco[0]) ? valorInstrucao0to15[15:11] : valorInstrucao16to20)
    );
  end
endmodule

// 00 => intrução[20:16]
// 01 => intrução[15:11]
// 10 => 29
// 11 => 31