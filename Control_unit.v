module Control_unit (
    input wire clk,
    input wire reset,

    // Flags

    input wire O,
    input wire LT,
    input wire GT,

    // opcode e funct
    
    input wire [5:0] OPCODE,
    input wire [5:0] FUNCT,

    // Sinais de controle de
        // 1 bit
            output reg PCWrite,
            output reg MemWrite,
            output reg MemRead,
            output reg IRWrite,

        // 2 bits
            output reg [1:0] ALUSrcA,
            output reg [1:0] ALUSrcB,
            output reg [1:0] RegWriteMUX,

        // 3 bits
            output reg [2:0] MuxAddr,
            output reg [2:0] ALUControl,
            output reg [2:0] PCSrc,

        // 4 bits 
            output reg [3:0] WriteDataCtrl,
    
    // reset especial

    output reg rst_out
);


// variáveis

reg [5:0] estados;
reg [2:0] COUNTER;

// parâmetros dos estados

always @(posedge clk) begin
    
end

endmodule