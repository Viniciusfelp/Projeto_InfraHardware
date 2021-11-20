module MuxRegA (
  input wire [1:0]  ALUSrcA,
  input wire [31:0] PC_out,
  input wire [31:0] RegB,
  input wire [31:0] RegA,
  output reg [31:0] saidaMuxRegA

);

  always @(*) begin
    saidaMuxRegA = ((ALUSrcA[1])
      ? RegA : ((ALUSrcA[0]) ? RegB : PC_out)
    );
  end
  
endmodule