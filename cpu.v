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
    wire MEM_w;
    wire IR_w;
    wire RB_w;
    wire AB_w;
    wire ALUOut_w;
    wire EPC_w;

    // Controllers with more than 1 bit

    wire [2:0] ULA_c; // ULA controller

    // Controllers for muxes
    wire M_WREG;
    wire[1:0] M_ULAA;
    wire[1:0] M_ULAB;
    wire[2:0] M_PC_src;

    // Parts of the instructions

    wire[5:0] OPCODE;
    wire[4:0] RS;
    wire[4:0] RT;
    wire[15:0] OFFSET;

    // Data wires with less than 32 bits

    wire[4:0] WRITEREG_in;

    // Data wires with 32 bits

    wire[31:0] ULA_out;
    wire[31:0] PC_out;
    wire[31:0] MEM_in;
    wire[31:0] MEM_to_IR;
    wire[31:0] RB_to_A;
    wire[31:0] RB_to_B;
    wire[31:0] A_out;
    wire[31:0] B_out;
    wire[31:0] SXTND_out;
    wire[31:0] SL2_out;
    wire[31:0] ALUOut_out;
    wire[31:0] EPC_out;
    wire[31:0] MEM_addr;
    wire[31:0] PC_in;
    wire[31:0] tratamento; // Aquele negocio vermelho nao pensei em nome bom depois mudar
    wire[31:0] jump; // mesma coisa do comentário de cima, mas esse é do jump

    Registrador PC_(
        clk,
        reset,
        PC_w,
        PC_in,
        PC_Out
    );

    MuxMemoria Mux_MEM_(
        Mux_addr,
        PC_out,
        ULA_out,
        ALUOut_out,
        MEM_addr
    );

    Memoria MEM_(
        MEM_addr,
        clk,
        MEM_w,
        MEM_to_IR,
        MEM_in 
    );

    //signExtende 8 -> 32

    Instr_Reg IR_(
        clk,
        reset,
        IR_w,
        MEM_to_IR,
        OPCODE,
        RS,
        RT,
        OFFSET
    );

    // SHIFLEFT2 26 bits -> 28 bits

    MuxEscritaEnderecoReg M_WREG_(
        M_WREG,
        RT,
        OFFSET,
        WRITEREG_in
    );


    //MUXWRITEDATA

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
        A_out
    );

    Registrador B_(
        clk,
        reset,
        AB_w,
        RB_to_B,
        B_out
    );

    SignExtend16to32 SXTND_(
        OFFSET,
        SXTND_out
    );

    ShiftLeft2 SL2_(
        SXTND_out,
        SL2_out
    );

    //MUXALU_src_A

    MUXUlaB M_ULAB_(
        M_ULAB,
        B_out,
        SXTND_out,
        SL2_out,
        ULAB_out
    );

    ula32 ULA_(
        ULAA_out,
        ULAB_out,
        ULA_c,
        ULA_out,
        Of,
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
        ULA_out,
        ALUOut_out
    );

    Registrador EPC_(
        clk,
        reset,
        EPC_w,
        ULA_out,
        EPC_out
    );

    Mux_PC_src M_PC_src_(
        M_PC_src,
        ULA_out,
        ALUOut_out,
        jump,
        tratamento,
        EPC_out,
        PC_in
    );

    ctrl_unit CTRL_(
        clk,
        reset,
        Of,
        Ng,
        Zero,
        Eq,
        Gt,
        Lt,
        OPCODE,
        PC_w,
        MEM_w,
        IR_w,
        RB_w,
        AB_w,
        ULA_c,
        M_Wreg,
        M_ULAA,
        M_ULAB,
        reset
    );


endmodule
