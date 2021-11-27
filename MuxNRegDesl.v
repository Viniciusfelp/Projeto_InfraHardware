module MuxNRegDesl (
  input wire [1:0] ShiftN,
  input wire [4:0] shamt,
  input wire [4:0] FioNaoFunciona,
  input wire [4:0] RT,

  output reg [4:0] RegDeslN
);

  always @(*) begin
    RegDeslN = ((ShiftN[1]) ? (RT) : ((ShiftN[0]) ? FioNaoFunciona : shamt));
  end
endmodule

// 00 => shamt
// 01 => FioNaoFunciona
// 10 => RT