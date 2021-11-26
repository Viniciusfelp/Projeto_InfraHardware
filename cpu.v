module cpu(
    input   wire clk,
    input wire reset
);

    // Flags
    wire Of;
    wire Ng;
    wire Zero;
    wire Eq;
    wire Gt;
    wire Lt;


    // Controllers with 1 bit
    wire PC_w;
    wire MEM_wr;
    wire IR_w;
    wire RB_w;
    wire AB_w;
    wire ALUOut_w;
    wire EPC_w;
    wire MemDR_w;

    // Controllers with more than 1 bit

    wire [2:0] ULA_c; // ULA controller

    // Controllers for muxes
    wire [1:0] M_WREG;
    wire [1:0] ShifN;
    wire [1:0] ShifInput;
    wire[1:0] M_ULAA;
    wire[1:0] M_ULAB;
    wire[2:0] M_PC_src;
    wire[3:0] M_WD;
    wire[2:0] Mux_addr;

    // Parts of the instructions

    wire[5:0] OPCODE;
    wire[4:0] RS;
    wire[4:0] RT;
    wire[15:0] addr_or_immed;
    wire[4:0] RD = addr_or_immed[15:11];
    wire[4:0] shamt = addr_or_immed[10:6];
    wire[5:0] funct = addr_or_immed[5:0];
    wire[25:0] offset = {RS, RT, addr_or_immed};

    // Data wires with less than 32 bits
    wire [31:0] RegDeslInput;
    wire [31:0] RegDeslN; // TODO aqui é 32 bits ou 16?
    wire[4:0] WRITEREG_in;

    // Data wires with 32 bits

    wire[31:0] ALU_out;
    wire[31:0] PC_out;

    wire[31:0] MEM_in;
    wire[31:0] MEM_to_IR; 
    wire[31:0] RB_to_A; // Banco de registradores para o registrador A
    wire[31:0] RB_to_B; // Banco de registradores para o registrador B
    wire[31:0] ULAA_in;
    wire[31:0] ULAB_in;
    wire[31:0] SXTND_out; // Sign extend 16 to 32
    wire[31:0] SL2_out; // Saida do shift left 2 
    wire[31:0] ALUOut_out;

    wire[31:0] EPC_out; 
    wire[31:0] RegA_out;
    wire[31:0] RegB_out;

    wire[31:0] MEM_addr; //Endereço de memoria a ser carregado
    wire[31:0] PC_in; // Entrado do PC
    wire[31:0] tratamento; // Aquele negocio vermelho nao pensei em nome bom depois mudar

    wire[27:0] SL26to28_out;//Shiftleft2 que altera de 26 bits para 28

    ShiftLeft2_26to28 SL(offset, SL26to28_out);
    
    wire[31:0] jump = {PC_out, SL26to28_out}; //endereco de jump


    wire[31:0] MemDR_out; // valor de saida do Memory data register 

    wire[31:0] HI_out; // TODO
    wire[31:0] LO_out; // TODO

    wire[31:0] RegDesl_out; // TODO Saida do registrador de deslocamento

    wire[31:0] ShiftL16_out; // TODO implementar shiftLeft16
    wire[31:0] Lt_out;
    wire[31:0] WD_out; // Saida do multiplexador do write data


    Registrador PC_(
        clk,
        reset,
        PC_w,
        PC_in,
        PC_out
    );

    //Multiplexador que define o endereço da memória a ser buscado
    MuxMemoria Mux_MEM_(
        Mux_addr,
        PC_out,
        ALU_out,
        ALUOut_out,
        MEM_addr
    );

    Memoria MEM_(
        MEM_addr,
        clk,
        MEM_wr,
        MEM_to_IR,
        MEM_in 
    );

    // TODO signExtende 8 -> 32

    Registrador MemoryDataRegister_(
        clk,
        reset,
        MemDR_w,
        MEM_to_IR,
        MemDR_out
    );

    Instr_Reg IR_(
        clk,
        reset,
        IR_w,
        MEM_to_IR,
        OPCODE,
        RS,
        RT,
        addr_or_immed
    );

    // Multiplexador write register
    MuxEscritaEnderecoReg M_WREG_(
        M_WREG,
        RT,
        addr_or_immed,
        WRITEREG_in
    );

    MuxInputRegDesl MuxInputRegDesl_(
        ShifInput,
        RegB_out,
        RegA_out,
        RegDeslInput
    );

    MuxNRegDesl MuxNRegDesl_(
        ShifN,
        addr_or_immed,
        MemDR_out,
        RegB_out,
        RegDeslN
    );

    RegDesloc RegDesl_(
        clk,
        reset,
        shiftCrtl,
        RegDeslN,
        RegDeslInput,
        RegDesl_out
    );


    wire[31:0] MemDR_outLB = {24'd0, MemDR_out[7:0]}; // Valor a ser carregado em um load byte
    wire[31:0] MemDR_outLH = {16'd0, MemDR_out[15:0]}; // Valor a ser carregado em um load half

    //MUXWRITEDATA define o valor de saida do multiplexador do write data
    MuxWriteData M_WD_(
        M_WD,
        MemDR_outLB, 
        MemDR_outLH, 
        ALUOut_out,
        MemDR_out,
        HI_out,
        ALU_out,
        LO_out,
        RegDesl_out, //Saida do registrador de deslocamento
        ShiftL16_out, // implementar shiftLeft16
        Lt_out, // Transformar Lt de 1 bit para 32
        WD_out
    );

    Banco_reg REG_BASE_(
        clk,
        reset,
        RB_w,
        RS,
        RT,
        WRITEREG_in,
        RB_to_A,
        RB_to_B
    );

    Registrador A_(
        clk,
        reset,
        AB_w,
        RB_to_A,
        RegA_out
        
    );

    Registrador B_(
        clk,
        reset,
        AB_w,
        RB_to_B,
        RegB_out 

    );

    SignExtend16to32 SXTND_(
        addr_or_immed,
        SXTND_out
    );

    // ShiftLeft2 -> multiplicar por 2
    ShiftLeft2 SL2_(
        SXTND_out,
        SL2_out
    );

    // Multiplexador que define o valor do A da ULA
    MuxRegA M_ULAA_(
        M_ULAA,
        PC_out,
        RegB_out,  // TODO
        RegA_out,
        ULAA_in  // TODO

    );

    //Multiplexador que define o valor de B
    MuxUlaB M_ULAB_(
        M_ULAB,
        RegB_out,
        SXTND_out,
        SL2_out,
        ULAB_in

    );

    Ula32 ULA_(
        ULAA_in,
        ULAB_in,
        ULA_c,
        ALU_out,
        Ng,
        Zero,
        Eq,
        Gt,
        Lt
    );
    
    Registrador ALUOut_(
        clk,
        reset,
        ALUOut_w,
        ALU_out,
        ALUOut_out
    );

    Registrador EPC_(
        clk,
        reset,
        EPC_w,
        ALU_out,
        EPC_out
    );

    // Multiplexador que define o valor do PC
    Mux_PC_src M_PC_src_(
        M_PC_src,
        ALU_out,
        ALUOut_out,
        jump,
        tratamento,
        EPC_out,
        PC_in
    );


    Control_unit UnidadeDeControle(
            clk,
            reset,
            Of,
            Lt,
            Gt,
            OPCODE,
            funct,
            PC_w,
            MEM_wr,
            IR_w,
            RB_w,
            M_ULAA,
            M_ULAB,
            ALUOut_w,
            M_WREG,
            Mux_addr,
            ULA_c,
            M_PC_src,
            M_WD,
            ShifN,
            ShifInput,
            reset_out
    );
    

endmodule