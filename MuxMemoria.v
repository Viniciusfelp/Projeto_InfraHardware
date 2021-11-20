module MuxMemoria (
  input  wire [2:0]  MuxAddr,
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
    auxiliar1 = ((MuxAddr[1])
      ? ((MuxAddr[0]) ? valor253 : valorResultadoUla)
      : ((MuxAddr[0]) ? valorResultadoAluOut : valorPC)
    );
    auxiliar2 = (MuxAddr[0]) ? valor255 : valor254;
    saidaMuxMemoria = (MuxAddr[2]) ? auxiliar2 : auxiliar1;
  end
endmodule

// 000 => auxiliar1 => valorPC
// 001 => auxiliar1 => valorResultadoAluOut
// 010 => auxiliar1 => valorResultadoUla
// 011 => auxiliar1 => 253
// 100 => auxiliar2 => 254
// 101 => auxiliar2 => 255