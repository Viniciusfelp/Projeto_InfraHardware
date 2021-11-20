module MuxMemoria (
  input  wire [3:0]  MuxAddr,
  input  wire [31:0] valorPC,
  input  wire [31:0] valorResultadoUla,
  input  wire [31:0] valorResultadoAluOut,

  output wire [31:0] saidaMuxMemoria
);
  parameter valor253 = 32'b00000000000000000000000011111101; // 253 em decimal
  parameter valor254 = 32'b00000000000000000000000011111110; // 254 em decimal
  parameter valor255 = 32'b00000000000000000000000011111111; // 255 em decimal

  reg [31:0] auxiliar1;
  reg [31:0] auxiliar2;

  always @(*) begin
    auxiliar1 = ((seletorMuxMemoria[1])
      ? ((seletorMuxMemoria[0]) ? valor253 : valorResultadoUla)
      : ((seletorMuxMemoria[0]) ? valorResultadoAluOut : valorPC)
    );
    auxiliar2 = (seletorMuxMemoria[0]) ? valor255 : valor254;
    saidaMuxMemoria = (seletorMuxMemoria[2]) ? auxiliar2 : auxiliar1;
  end
endmodule

// 0000 => auxiliar1 => valorPC
// 0001 => auxiliar1 => valorResultadoAluOut
// 0010 => auxiliar1 => valorResultadoUla
// 0011 => auxiliar1 => 253
// 0100 => auxiliar2 => 254
// 0101 => auxiliar2 => 255