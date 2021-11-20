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
reg [4:0] COUNTER;

// parâmetros dos estados

parameter resetado = 6'd0;
parameter fetch = 6'd1;
parameter decode = 6'd2;


//opcodes
parameter ADD = 6'd0;

initial begin
    //227 no reg 29
    rst_out = 1'b1;
end
always @(posedge clk) begin
    if (reset == 1'b1) begin
        if (estados != resetado) begin
		  
            estados = resetado;
            PCWrite = 1'd0;
            MemWrite = 1'd0;
            MemRead = 1'd0;
            IRWrite = 1'd0;
            ALUSrcA = 2'd0;
            ALUSrcB = 2'd0;
            RegWriteMUX = 2'd0;
            MuxAddr = 3'd0;
            ALUControl = 3'd0;
            PCSrc = 3'd0;
            WriteDataCtrl = 4'd0;
            COUNTER = 3'd0;
            
        end
    end
end


endmodule