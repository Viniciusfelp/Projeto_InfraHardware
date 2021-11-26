module MuxNRegDesl (
  input wire [1:0] ShifN,
  input wire [15:0] addr_or_immed,
  input wire [31:0] MemDR_out,
  input wire [31:0] RegB_out,

  output reg [31:0] RegDeslN
);

  always @(*) begin
    RegDeslInput = ((Shifn[1]) ? (RegB_out) : ((ShifN[0]) ? MemDR_out : addr_or_immed));
  end
endmodule

// 00 => addr_or_immed
// 01 => MemDR_out
// 10 => RegB_out