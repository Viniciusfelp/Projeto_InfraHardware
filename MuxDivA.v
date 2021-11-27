module MuxDivA (
  input wire DIVA,
  input wire [31:0] MemDR_out,
  input wire [31:0] RegA_out,
  output reg [31:0] MuxDivA_out
);

  always @(*) begin
    MuxDivA_out = (DIVA ? MemDR_out : MultHI);
  end
endmodule

// 0 => RegA_out
// 1 => MemDR_out