module Mux1to3 (
  input  wire [1:0]  seletorMux1to3,

  output reg [31:0] saidaMux1to3
);
  parameter valor1 = 32'b00000000000000000000000000000001; // 1 em decimal
  parameter valor2 = 32'b00000000000000000000000000000010; // 2 em decimal
  parameter valor3 = 32'b00000000000000000000000000000011; // 3 em decimal

  always @(*) begin
    saidaMux1to3 = ((seletorMux1to3[1])
      ? ((seletorMux1to3[0]) ? valor3 : valor3)
      : ((seletorMux1to3[0]) ? valor2 : valor1)
    );
  end
endmodule