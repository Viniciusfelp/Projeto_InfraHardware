module MuxWriteData (
  input  wire [3:0]  WriteDataCtrl,
  input  wire [31:0] MDR7Concatenated,
  input  wire [31:0] MDR15Concatenated,
  input  wire [31:0] valorResultadoAluOut,
  input  wire [31:0] SaidaMDR,
  input  wire [31:0] SaidaHI,
  input  wire [31:0] SaidaALU,
  input  wire [31:0] SaidaLO,
  input  wire [31:0] SaidaRegDesl,
  input  wire [31:0] SaidaShiftL16,
  input  wire [31:0] SaidaLT,

  output reg [31:0] saidaMuxWriteData
);

  parameter valor227 = 32'd227; // 227 em decimal

  reg [31:0] auxiliar1;
  reg [31:0] auxiliar2;
  reg [31:0] auxiliar3;

  always @(*) begin
    auxiliar1 = ((WriteDataCtrl[1])
      ? ((WriteDataCtrl[0]) ? SaidaMDR : valorResultadoAluOut)
      : ((WriteDataCtrl[0]) ? MDR15Concatenated : MDR7Concatenated)
    );
    auxiliar2 = ((WriteDataCtrl[1]) ? ((WriteDataCtrl[0]) ? SaidaRegDesl : SaidaLO)
      : ((WriteDataCtrl[0]) ? SaidaALU : SaidaHI));
    auxiliar3 = WriteDataCtrl[0] ? SaidaLT : SaidaShiftL16;
    saidaMuxWriteData = ((WriteDataCtrl[3]) ? (auxiliar3) : (WriteDataCtrl[2] ? auxiliar2 : auxiliar1));
  end
endmodule

// 0000 => auxiliar1 => MDR7Concatenated
// 0001 => auxiliar1 => MDR15Concatenated
// 0010 => auxiliar1 => valorResultadoAluOut
// 0011 => auxiliar1 => SaidaMDR
// 0100 => auxiliar2 => SaidaHI
// 0101 => auxiliar2 => SaidaALU
// 0110 => auxiliar2 => SaidaLO
// 0111 => auxiliar2 => SaidaRegDesl
// 1000 => auxiliar3 => SaidaShiftL16
// 1001 => auxiliar3 => SaidaLT
