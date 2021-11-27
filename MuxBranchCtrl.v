module MuxBranchCtrl (
  input wire [1:0]  BranchCtrl,
  input wire Zero,
  input wire ZeroNegado,
  input wire Gt,
  input wire GtNegado,

  output reg MuxBranchCtrl_
);

  always @(*) begin
    MuxBranchCtrl_ = ((BranchCtrl[1])
      ? ((BranchCtrl[0]) ? GtNegado : Gt)
      : ((BranchCtrl[0]) ? ZeroNegado : Zero)
    );
  end
endmodule

// 00 => Zero
// 01 => ZeroNegado
// 10 => Gt
// 11 => GtNegado