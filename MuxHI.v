module MuxHI (
  input wire HIMuxCtrl,
  input wire [31:0] MultHI,
  input wire [31:0] DivHI,
  output reg [31:0] HIMux_out
);

  always @(*) begin
    HIMux_out = (HIMuxCtrl ? DivHI : MultHI);
  end
endmodule

// 0 => MultHI
// 1 => DivHI