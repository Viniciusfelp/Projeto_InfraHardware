module Control_unit (
    input wire clk,
    input wire reset,

    // Flags

    input wire O,
    input wire LT,
    input wire GT,

    // opcode e funct
    
    input wire [5:0] OPCODE,
    input wire [5:0] funct,

    // Sinais de controle de
        // 1 bit
            output reg PCWrite,
            output reg MemWR,
            output reg IRWrite,

        // 2 bits
            output reg [1:0] ALUSrcA,
            output reg [1:0] ALUSrcB,
            output reg ALUOut_w,
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
parameter intermFetchDecode = 6'd2;
parameter decode = 6'd3;


//opcodes
parameter R_TYPE = 6'd0;
parameter RESET = 6'b111111 ;

//functs
parameter ADD = 6'd32;

initial begin
    //227 no reg 29
    rst_out = 1'b1;
end
always @(posedge clk) begin
    if (reset == 1'b1) begin
        if (estados != resetado) begin
            estados = resetado;
            PCWrite = 1'd0;
            MemWR = 1'd0;
            MemWR = 1'd0;
            IRWrite = 1'd1;
            ALUSrcA = 2'd0;
            ALUSrcB = 2'd0;
            ALUOut_w = 1'd0;
            RegWriteMUX = 2'b01;
            MuxAddr = 3'd0;
            ALUControl = 3'd0;
            PCSrc = 3'd0;
            WriteDataCtrl = 4'b1010;
            COUNTER = 3'd0;
            rst_out = 1'd1;
        end
        else begin
            estados = resetado;
            PCWrite = 1'd0;
            MemWR = 1'd0;
            MemWR = 1'd0;
            IRWrite = 1'd1;
            ALUSrcA = 2'd0;
            ALUSrcB = 2'd0;
            ALUOut_w = 1'd0;
            RegWriteMUX = 2'b01;
            MuxAddr = 3'd0;
            ALUControl = 3'd0;
            PCSrc = 3'd0;
            WriteDataCtrl = 4'b1010;
            COUNTER = 3'd0;
            rst_out = 1'd1;
        end
    end
    else begin
        case (estados)
            fetch: begin
                if (COUNTER == 5'd0 || COUNTER == 5'd1 || COUNTER == 5'd2) begin
                    // calcula PC+4 (mas não grava ainda) e lê memória
                    estados = fetch;
                    PCWrite = 1'd0;
                    MemWR = 1'd0; 
                    MemWR = 1'd1;  ///
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'b01;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b01;
                    MuxAddr = 3'd0;   ///
                    ALUControl = 3'b001;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;  ///
                    rst_out = 1'd0;
                    if (COUNTER == 5'd2) begin
                        estados = intermFetchDecode;
                        COUNTER = COUNTER + 1;
                    end
                    else begin
                        COUNTER = COUNTER + 1;   
                    end
                end
            end

            intermFetchDecode: begin
                // grava PC+4 no PC e escreve no IR
                estados = decode;
                PCWrite = 1'd1;  ///
                MemWR = 1'd0; 
                MemWR = 1'd0;  ///
                IRWrite = 1'd1;  ///
                ALUSrcA = 2'd0;  ///
                ALUSrcB = 2'd0;  ///
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'b01;
                MuxAddr = 3'd0;
                ALUControl = 3'b000;  ///
                PCSrc = 3'd0;  ///
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                rst_out = 1'd0;
            end

            decode: begin
                if (COUNTER == 5'd4) begin
                    // calcula o endereço de branch e lê no banco de registradores
                    estados = decode;
                    PCWrite = 1'd0;  ///
                    MemWR = 1'd0; 
                    MemWR = 1'd0;  ///
                    IRWrite = 1'd0;  ///
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'd1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b01;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b001;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    rst_out = 1'd0;
                end   
                else if (COUNTER == 5'd5) begin
                    // escreve no ALUOut e nos A e B
                    case (OPCODE) // adicionar default para tratamento de exceção
                        R_TYPE: begin
                            case (funct) 
                                ADD: begin
                                    estados = ADD;
                                end
                            endcase
                        end
                    endcase

                    PCWrite = 1'd0;
                    MemWR = 1'd0; 
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;  ///
                    ALUOut_w = 1'd1;  ///
                    RegWriteMUX = 2'b01;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    rst_out = 1'd0;
                end      
            end
        
        endcase
    end
end


endmodule