module Store (
    input wire[1:0] storeOp,
    input wire[31:0] b_in,
    input wire[31:0] mem_in,
    input wire[31:0] storeOut
);

    assign storeOut = storeOp[1] ? {mem_in[31:8], b_in[7:0]} : storeOp[0] ? {mem_in[31:16], b_in[15:0]} : b_in;
    
endmodule


// 00 -> LW
// 01 -> LH
// 1x -> LB