module Mux_PC_src (
    input wire[2:0] PC_src,
    input wire[31:0] ULA_out,
    input wire[31:0] ALUOut_out,
    input wire[31:0] jump,
    input wire[31:0] negocioVermelho,//mudar nome n lembro oq faz
    input wire[31:0] EPC_out,
    
    output wire[31:0] PC_in
);

    assign PC_in = (PC_src == 3'b000) ? ULA_out :
                   (PC_src == 3'b001) ? ALUOut_out :
                   (PC_src == 3'b010) ? jump :
                   (PC_src == 3'b011) ? negocioVermelho :
                   (PC_src == 3'b100) ? EPC_out: 
                   32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; 

endmodule