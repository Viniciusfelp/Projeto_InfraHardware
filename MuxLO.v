module MuxLO (
  input wire LOMuxCtrl,
  input wire [31:0] DivLO,
  input wire [31:0] MultLO,
  output reg [31:0] LOMux_out
);

  always @(*) begin
    LOMux_out = (LOMuxCtrl ? MultLO : DivLO);
  end
endmodule

// 0 => DivLO
// 1 => MultLO