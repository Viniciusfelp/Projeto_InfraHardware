module MuxInputRegDesl (
  input wire ShifInput,
  input wire [31:0] RegB_out,
  input wire [31:0] RegA_out,
  output reg [31:0] RegDeslInput
);

  always @(*) begin
    RegDeslInput = (ShifInput ? RegA_out : RegB_out);
  end
endmodule

// 0 => RegB_out
// 1 => RegA_out