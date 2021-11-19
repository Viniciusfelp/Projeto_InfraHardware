module SignExtend1to32(
input wire slt,
output reg [31:0] saidaSignExtend1to32
);

always @(*) begin
  saidaSignExtend1to32 = (32'b00000000000000000000000000000000 + slt);
end

endmodule