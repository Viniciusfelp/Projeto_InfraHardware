module Control_unit (
    input wire clk,
    input wire reset,

    // Flags

    input wire Of,
    input wire LT,
    input wire GT,

    // opcode e funct
    
    input wire [5:0] OPCODE,
    input wire [5:0] funct,

    // Sinais de controle

            output reg PCWrite,
            output reg PCWriteCond,
            output reg MemWR,
            output reg IRWrite,
            output reg RegWrite,


            output reg [1:0] ALUSrcA,
            output reg [1:0] ALUSrcB,
            output reg ALUOut_w,
            output reg [1:0] RegWriteMUX,


            output reg [2:0] MuxAddr,
            output reg [2:0] ALUControl,
            output reg [2:0] PCSrc,

            output reg [3:0] WriteDataCtrl,
            output reg [1:0] ShiftN,
            output reg [2:0] ShiftInput,
            output reg [2:0] shiftCtrl,
            output reg HIMuxCtrl,
            output reg LOMuxCtrl,
            output reg HI_w,
            output reg LO_w,
            output reg DIVA,
            output reg DIVB,
            output reg MemDR_w,
            output reg [1:0] BranchCtrl,
    
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
parameter estadoADD = 6'd4;
parameter estadoSUB = 6'd5;
parameter estadoAND = 6'd6;
parameter estadoSLT = 6'd7;
parameter estadoRTE = 6'd8;
parameter estadoBREAK = 6'd9;
parameter estadoJR = 6'd10;
parameter estadoSLL = 6'd11;
parameter estadoSLLV = 6'd12;
parameter estadoSRA = 6'd13;
parameter estadoSRAV = 6'd14;
parameter estadoSRL = 6'd15;
parameter estadoBEQ = 6'd16;
parameter estadoJ = 6'd17;
parameter estadoADDI = 6'd18;
parameter estadoADDIU = 6'd19;
parameter estadoLB = 6'd20;
parameter estadoLH = 6'd21;
parameter estadoLW = 6'd22;
parameter estadoBNE = 6'd23;
parameter estadoBGT = 6'd24;
parameter estadoBLE = 6'd25;

//opcodes
parameter R_TYPE = 6'd0;
parameter RESET = 6'b111111;
parameter ADDI = 6'd8;
parameter ADDIU = 6'd9;
parameter BEQ = 6'd4;
parameter BNE = 6'd5;
parameter BLE = 6'd6;
parameter BGT = 6'd7;
parameter SRAM = 6'd1;
parameter LB = 6'd32;
parameter LH = 6'd33;
parameter LUI = 6'd15;
parameter LW = 6'd35;
parameter SB = 6'd40;
parameter SH = 6'd41;
parameter SLTI = 6'd10;
parameter SW = 6'd43;
parameter J = 6'd2;
parameter JAL = 6'd3;

//functs
parameter ADD = 6'd32;
parameter AND = 6'd36;
parameter DIV = 6'd26;
parameter MULT = 6'd24;
parameter JR = 6'd8;
parameter MFHI = 6'd16;
parameter MFLO = 6'd18;
parameter SLL = 6'd0;
parameter SLLV = 6'd4;
parameter SLT = 6'd42;
parameter SRA = 6'd3;
parameter SRAV = 6'd7;
parameter SRL = 6'd2;
parameter SUB = 6'd34;
parameter BREAK = 6'd13;
parameter RTE = 6'd19;
parameter DIVM = 6'd5;

initial begin
    //227 no reg 29
    rst_out = 1'b1;
end
always @(posedge clk) begin
    if (reset == 1'b1) begin
        if (estados != resetado) begin
            estados = resetado;
            PCWrite = 1'd0;
            PCWriteCond = 1'd0;
            MemWR = 1'd0;
            IRWrite = 1'd1;
            ALUSrcA = 2'd0;
            ALUSrcB = 2'd0;
            RegWrite = 1'd0;
            ALUOut_w = 1'd0;
            RegWriteMUX = 2'b01;
            MuxAddr = 3'd0;
            ALUControl = 3'd0;
            PCSrc = 3'd0;
            WriteDataCtrl = 4'b1010;
            COUNTER = 3'd0;
            ShiftN = 2'd0;
            ShiftInput = 1'd0;
            shiftCtrl = 3'd0;
            HIMuxCtrl = 1'd0; 
            LOMuxCtrl = 1'd0; 
            HI_w = 1'd0; 
            LO_w = 1'd0; 
            DIVA = 1'd0; 
            DIVB = 1'd0; 
            MemDR_w = 1'd0;
            BranchCtrl = 2'd0;
            rst_out = 1'd1;
            
        end
        else begin
            estados = resetado;
            PCWrite = 1'd0;
            PCWriteCond = 1'd0;
            MemWR = 1'd0;
            IRWrite = 1'd1;
            ALUSrcA = 2'd0;
            ALUSrcB = 2'd0;
            RegWrite = 1'd0;
            ALUOut_w = 1'd0;
            RegWriteMUX = 2'b01;
            MuxAddr = 3'd0;
            ALUControl = 3'd0;
            PCSrc = 3'd0;
            WriteDataCtrl = 4'b1010;
            COUNTER = 3'd0;
            ShiftN = 2'd0;
            ShiftInput = 1'd0;
            shiftCtrl = 3'd0;
            HIMuxCtrl = 1'd0; 
            LOMuxCtrl = 1'd0; 
            HI_w = 1'd0; 
            LO_w = 1'd0; 
            DIVA = 1'd0; 
            DIVB = 1'd0; 
            MemDR_w = 1'd0;
            BranchCtrl = 2'd0;
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
                    PCWriteCond = 1'd0;
                    MemWR = 1'd1;  ///
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'b01;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b01;
                    MuxAddr = 3'd0;   ///
                    ALUControl = 3'b001;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;  ///
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
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
                PCWriteCond = 1'd0;
                MemWR = 1'd0;  ///
                IRWrite = 1'd1;  ///
                ALUSrcA = 2'd0;  ///
                ALUSrcB = 2'd0;  ///
                RegWrite = 1'd0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'b01;
                MuxAddr = 3'd0;
                ALUControl = 3'b000;  ///
                PCSrc = 3'd0;  ///
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end

            decode: begin
                if (COUNTER == 5'd4) begin
                    // calcula o endereço de branch e lê no banco de registradores
                    estados = decode;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;  ///
                    MemWR = 1'd0;  ///
                    IRWrite = 1'd0;  ///
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'd1;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b01;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b001;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end   
                else if (COUNTER == 5'd5) begin
                    // escreve no ALUOut e nos A e B
                    estados = decode;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0; 
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd1;  ///
                    RegWriteMUX = 2'b01;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end      
                else if (COUNTER == 5'd6) begin
                    // troca de estados e reseta o resto
                    case (OPCODE) // adicionar default para tratamento de exceção
                        R_TYPE: begin
                            case (funct) 
                                ADD: begin
                                    estados = estadoADD;
                                end
                                SUB: begin
                                    estados = estadoSUB;
                                end
                                AND: begin
                                    estados = estadoAND;
                                end
                                SLT: begin
                                    estados = estadoSLT;
                                end
                                RTE: begin
                                    estados = estadoRTE;
                                end
                                BREAK: begin
                                    estados = estadoBREAK;
                                end
                                JR: begin
                                    estados = estadoJR;
                                end
                                SLL: begin
                                    estados = estadoSLL;
                                end
                                SLLV: begin
                                    estados = estadoSLLV;
                                end
                                SLT: begin
                                    estados = estadoSLT;
                                end
                                SRA: begin
                                    estados = estadoSRA;
                                end
                                SRAV: begin
                                    estados = estadoSRAV;
                                end
                                SRL: begin
                                    estados = estadoSRL;
                                end
                            endcase
                        end
                        BEQ: begin
                            estados = estadoBEQ;
                        end
                        BNE: begin
                            estados = estadoBNE;
                        end
                        BGT: begin
                            estados = estadoBGT;
                        end
                        BLE: begin
                            estados = estadoBLE;
                        end
                        LH: begin
                            estados = estadoLH;
                        end
                        LW: begin
                            estados = estadoLW;
                        end
                        J: begin
                            estados = estadoJ;
                        end
                        ADDI: begin
                            estados = estadoADDI;
                        end
                        ADDIU: begin
                            estados = estadoADDIU;
                        end
                        LB: begin
                            estados = estadoLB;
                        end
                    endcase
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0; 
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'd0;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end

            estadoADD: begin
                if (COUNTER == 5'd0) begin
                    // realiza a soma
                    estados = estadoADD;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd2;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b001;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // guarda no banco de registradores e volta pro estado de fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0; 
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd3;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd5;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end

            estadoSUB: begin
                if (COUNTER == 5'd0) begin
                    // realiza a subtração
                    estados = estadoSUB;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd2;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b010;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // guarda no banco de registradores e volta pro estado de fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0; 
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd3;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd5;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end
            estadoAND: begin
                if (COUNTER == 5'd0) begin
                    // realiza o AND
                    estados = estadoAND;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd2;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b011;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // guarda no banco de registradores e volta pro estado de fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0; 
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd3;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd5;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end

            estadoSLT: begin
                if (COUNTER == 5'd0) begin
                    // realiza a comparação
                    estados = estadoSLT;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd2;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b111;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // guarda no banco de registradores e volta pro estado de fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0; 
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd3;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'b1001;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end
            
            estadoRTE: begin
                //guarda em PC e volta pra fetch em seguida
                estados = fetch;
                PCWrite = 1'd1; ///
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'd0; 
                ALUSrcB = 2'd0;
                RegWrite = 1'd0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b000;
                PCSrc = 3'b100;  ///
                WriteDataCtrl = 4'd0;
                COUNTER = 5'd0;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end

            estadoBREAK: begin
                if (COUNTER == 5'd0) begin
                    // realiza PC - 4
                    estados = estadoBREAK;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'b00;  ///
                    ALUSrcB = 2'b01;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b010;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // guarda em PC e volta pra fetch
                    estados = fetch;
                    PCWrite = 1'd1; ///
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'd0;  ///
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'b000;  ///
                    WriteDataCtrl = 4'd0;
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end
            
            estadoJR: begin
                if (COUNTER == 5'd0) begin
                    // dá hold em A
                    estados = estadoJR;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'b10;  ///
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // guarda em PC e volta pra fetch
                    estados = fetch;
                    PCWrite = 1'd1; ///
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;  ///
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;  ///
                    PCSrc = 3'b101;  ///
                    WriteDataCtrl = 4'd0;
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end 

            estadoSLL: begin
                if (COUNTER == 5'd0) begin
                    // dá load no registrador
                    estados = estadoSLL;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;  ///
                    ShiftInput = 1'd0;  ///
                    shiftCtrl = 3'b001;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // faz o shift
                    estados = estadoSLL;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;  ///
                    ShiftInput = 1'd0;  ///
                    shiftCtrl = 3'b010;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd2) begin
                    // escreve no banco de registradores e volta pra fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'b1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b11;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'b0111;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end

            estadoSLLV: begin
                if (COUNTER == 5'd0) begin
                    // dá load no registrador
                    estados = estadoSLLV;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'b10;  ///
                    ShiftInput = 1'b1;  ///
                    shiftCtrl = 3'b001;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // faz o shift
                    estados = estadoSLLV;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;  ///
                    ShiftInput = 1'd0;  ///
                    shiftCtrl = 3'b010;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd2) begin
                    // escreve no banco de registradores e volta pra fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'b1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b11;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'b0111;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end

            estadoSRA: begin
                if (COUNTER == 5'd0) begin
                    // dá load no registrador
                    estados = estadoSRA;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'b00;  ///
                    ShiftInput = 1'b0;  ///
                    shiftCtrl = 3'b001;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // faz o shift
                    estados = estadoSRA;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;  ///
                    ShiftInput = 1'd0;  ///
                    shiftCtrl = 3'b100;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd2) begin
                    // escreve no banco de registradores e volta pra fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'b1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b11;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'b0111;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end

            estadoSRAV: begin
                if (COUNTER == 5'd0) begin
                    // dá load no registrador
                    estados = estadoSRAV;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'b10;  ///
                    ShiftInput = 1'b1;  ///
                    shiftCtrl = 3'b001;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // faz o shift
                    estados = estadoSRAV;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;  ///
                    ShiftInput = 1'd0;  ///
                    shiftCtrl = 3'b100;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd2) begin
                    // escreve no banco de registradores e volta pra fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'b1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b11;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'b0111;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end

            estadoSRL: begin
                if (COUNTER == 5'd0) begin
                    // dá load no registrador
                    estados = estadoSRL;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'b00;  ///
                    ShiftInput = 1'b0;  ///
                    shiftCtrl = 3'b001;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd1) begin
                    // faz o shift
                    estados = estadoSRL;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'd0;
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'd0;
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'd0;
                    COUNTER = COUNTER + 1;
                    ShiftN = 2'd0;  ///
                    ShiftInput = 1'd0;  ///
                    shiftCtrl = 3'b011;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
                else if (COUNTER == 5'd2) begin
                    // escreve no banco de registradores e volta pra fetch
                    estados = fetch;
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    MemWR = 1'd0;
                    IRWrite = 1'd0;
                    ALUSrcA = 2'd0;
                    ALUSrcB = 2'd0;
                    RegWrite = 1'b1;  ///
                    ALUOut_w = 1'd0;
                    RegWriteMUX = 2'b11;  ///
                    MuxAddr = 3'd0;
                    ALUControl = 3'b000;
                    PCSrc = 3'd0;
                    WriteDataCtrl = 4'b0111;  ///
                    COUNTER = 5'd0;
                    ShiftN = 2'd0;
                    ShiftInput = 1'd0;
                    shiftCtrl = 3'd0;  ///
                    HIMuxCtrl = 1'd0; 
                    LOMuxCtrl = 1'd0; 
                    HI_w = 1'd0; 
                    LO_w = 1'd0; 
                    DIVA = 1'd0; 
                    DIVB = 1'd0; 
                    MemDR_w = 1'd0;
                    BranchCtrl = 2'd0;
                    rst_out = 1'd0;
                end
            end

        estadoBEQ: begin
            if (COUNTER == 5'd0) begin
                // faz o cálculo da igualdade através da subtração (se A-B=0 -> A=B)
                estados = estadoBEQ;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'b10;  ///
                ALUSrcB = 2'b00;  ///
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b010;  ///
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0; 
            end
            else if (COUNTER == 5'd1) begin
                // escreve em PC o endereço do branch e volta para fetch
                estados = fetch;
                PCWrite = 1'd0;
                PCWriteCond = 1'd1;  ///
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'd0;
                ALUSrcB = 2'd0;
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b000;
                PCSrc = 3'd1;  ///
                WriteDataCtrl = 4'd0;
                COUNTER = 5'd0;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'b00;  ///
                rst_out = 1'd0;
            end
        end
        
        estadoBNE: begin
            if (COUNTER == 5'd0) begin
                // faz o cálculo da desigualdade
                estados = estadoBNE;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'b10;  ///
                ALUSrcB = 2'b00;  ///
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b010;  ///
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0; 
            end
            else if (COUNTER == 5'd1) begin
                // escreve em PC o endereço do branch e volta para fetch
                estados = fetch;
                PCWrite = 1'd0;
                PCWriteCond = 1'd1;  ///
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'd0;
                ALUSrcB = 2'd0;
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b000;
                PCSrc = 3'd1;  ///
                WriteDataCtrl = 4'd0;
                COUNTER = 5'd0;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'b01;  ///
                rst_out = 1'd0;
            end
        end

        estadoBGT: begin
            if (COUNTER == 5'd0) begin
                // faz o cálculo do >
                estados = estadoBGT;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'b10;  ///
                ALUSrcB = 2'b00;  ///
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b111;  ///
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0; 
            end
            else if (COUNTER == 5'd1) begin
                // escreve em PC o endereço do branch e volta para fetch
                estados = fetch;
                PCWrite = 1'd0;
                PCWriteCond = 1'd1;  ///
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'd0;
                ALUSrcB = 2'd0;
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b000;
                PCSrc = 3'd1;  ///
                WriteDataCtrl = 4'd0;
                COUNTER = 5'd0;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'b01;  ///
                rst_out = 1'd0;
            end
        end

        estadoBLE: begin
            if (COUNTER == 5'd0) begin
                // faz o cálculo do <=
                estados = estadoBEQ;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'b10;  ///
                ALUSrcB = 2'b00;  ///
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b111;  ///
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0; 
            end
            else if (COUNTER == 5'd1) begin
                // escreve em PC o endereço do branch e volta para fetch
                estados = fetch;
                PCWrite = 1'd0;
                PCWriteCond = 1'd1;  ///
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'd0;
                ALUSrcB = 2'd0;
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b000;
                PCSrc = 3'd1;  ///
                WriteDataCtrl = 4'd0;
                COUNTER = 5'd0;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'b11;  ///
                rst_out = 1'd0;
            end
        end
        
        estadoADDI: begin
            if (COUNTER == 5'd0) begin
                // realiza a soma com o imediato
                estados = estadoADDI;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'b10;  ///
                ALUSrcB = 2'b10;  ///
                RegWrite = 1'd0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b001;  ///
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
            else if (COUNTER == 5'd1 && Of == 0) begin
                // guarda no banco de registradores e volta pro estado de fetch
                estados = fetch;
                PCWrite = 1'd0; 
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'd0;  ///
                ALUSrcB = 2'd0;  ///
                RegWrite = 1'd1;  ///
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd3;  ///
                MuxAddr = 3'd0;
                ALUControl = 3'b000;  ///
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd5;  ///
                COUNTER = 5'd0;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end 
            //else if(Of == 1) overflow TODO
        end

        estadoADDIU: begin
            if (COUNTER == 5'd0) begin
                // realiza a soma com imediato
                estados = estadoADDIU;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'b10;  ///
                ALUSrcB = 2'b10;  ///
                RegWrite = 1'd0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd0;
                ALUControl = 3'b001;  ///
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
            else if (COUNTER == 5'd1) begin
                // guarda no banco de registradores e volta pro estado de fetch
                estados = fetch;
                PCWrite = 1'd0; 
                PCWriteCond = 1'd0;
                MemWR = 1'd0;
                IRWrite = 1'd0;
                ALUSrcA = 2'd0;  ///
                ALUSrcB = 2'd0;  ///
                RegWrite = 1'd1;  ///
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd3;  ///
                MuxAddr = 3'd0;
                ALUControl = 3'b000;  ///
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd5;  ///
                COUNTER = 5'd0;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0; 
                LOMuxCtrl = 1'd0; 
                HI_w = 1'd0; 
                LO_w = 1'd0; 
                DIVA = 1'd0; 
                DIVB = 1'd0; 
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end 
        end
        estadoJ: begin
            //Escreve em PC o valor do jump e vai para o fetch
            estados = fetch;
            PCWrite = 1'd1; ///
            PCWriteCond = 1'd0;
            MemWR = 1'd0;
            IRWrite = 1'd0;
            ALUSrcA = 2'd0; 
            ALUSrcB = 2'd0;
            RegWrite = 1'd0;
            ALUOut_w = 1'd0;
            RegWriteMUX = 2'd0;
            MuxAddr = 3'd0;
            ALUControl = 3'b000;
            PCSrc = 3'b010;  ///
            WriteDataCtrl = 4'd0;
            COUNTER = 5'd0;
            ShiftN = 2'd0;
            ShiftInput = 1'd0;
            shiftCtrl = 3'd0;
            HIMuxCtrl = 1'd0; 
            LOMuxCtrl = 1'd0; 
            HI_w = 1'd0; 
            LO_w = 1'd0; 
            DIVA = 1'd0; 
            DIVB = 1'd0; 
            MemDR_w = 1'd0;
            BranchCtrl = 2'd0;
            rst_out = 1'd0;
        end
        
        estadoLB: begin
            if (COUNTER == 1 || COUNTER == 2 || COUNTER == 3) begin  
                //seleciona o endereço de memória a ser lido
                estados = estadoLB;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      ///
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd2;     ///
                ALUControl = 3'b000;  
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
            else if(COUNTER == 4) begin
                //Escreve no Memory data register o valor lido da memória
                estados = estadoLB;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      ///
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd2;     ///
                ALUControl = 3'b000;  
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd1; ///
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
            else if (COUNTER == 5) begin
                //escreve no banco de registradores
                estados = fetch;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b1;   ///
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0; ///
                MuxAddr = 3'd0;     
                ALUControl = 3'b000;    
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0; ///
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
        end

        estadoLH: begin
            if (COUNTER == 1 || COUNTER == 2 || COUNTER == 3) begin  
                //seleciona o endereço de memória a ser lido
                estados = estadoLB;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      ///
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd2;     ///
                ALUControl = 3'b000;  
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
            else if(COUNTER == 4) begin
                //Escreve no Memory data register o valor lido da memória
                estados = estadoLB;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      ///
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd2;     ///
                ALUControl = 3'b000;  
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd1;  ///
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
            else if (COUNTER == 5) begin
                //escreve no banco de registradores
                estados = fetch;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b1;   ///
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0; ///
                MuxAddr = 3'd0;     
                ALUControl = 3'b000;   
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd1; ///
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
        end

        estadoLW: begin
            if (COUNTER == 1 || COUNTER == 2 || COUNTER == 3) begin  
                //seleciona o endereço de memória a ser lido
                estados = estadoLB;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      ///
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd2;     ///
                ALUControl = 3'b000;  
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
            else if(COUNTER == 4) begin
                //Escreve no Memory data register o valor lido da memória
                estados = estadoLB;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      ///
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b0;
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0;
                MuxAddr = 3'd2;     ///
                ALUControl = 3'b000;  
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd0;
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd1; ///
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
            else if (COUNTER == 5) begin
                //escreve no banco de registradores
                estados = fetch;
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                MemWR = 1'd0;      
                IRWrite = 1'd0;
                ALUSrcA = 2'b00;  
                ALUSrcB = 2'b00;  
                RegWrite = 1'b1;   ///
                ALUOut_w = 1'd0;
                RegWriteMUX = 2'd0; ///
                MuxAddr = 3'd0;     
                ALUControl = 3'b000;    
                PCSrc = 3'd0;
                WriteDataCtrl = 4'd3; ///
                COUNTER = COUNTER + 1;
                ShiftN = 2'd0;
                ShiftInput = 1'd0;
                shiftCtrl = 3'd0;
                HIMuxCtrl = 1'd0;
                LOMuxCtrl = 1'd0;
                HI_w = 1'd0;
                LO_w = 1'd0;
                DIVA = 1'd0;
                DIVB = 1'd0;
                MemDR_w = 1'd0;
                BranchCtrl = 2'd0;
                rst_out = 1'd0;
            end
        end

        endcase
    end
end


endmodule