// ===========================================================================
// Module   : imem  (instruction ROM, Tiny Tapeout trimmed version)
// 16-word ROM holding the Hyper Core main firmware.
// ===========================================================================
`include "core_defs.vh"
module imem (
    input  wire        clk,
    input  wire [31:0] addr,
    output reg  [31:0] rdata
);

parameter AW = 4;
localparam WORDS = (1 << AW);

reg [31:0] rom [0:WORDS-1];

wire [AW-1:0] word_addr = addr[AW+1:2];

function [31:0] enc_r;
    input [6:0] f7;  input [4:0] rs2; input [4:0] rs1;
    input [2:0] f3;  input [4:0] rd;  input [6:0] op;
    begin enc_r = {f7, rs2, rs1, f3, rd, op}; end
endfunction

function [31:0] enc_i;
    input [11:0] imm; input [4:0] rs1; input [2:0] f3;
    input [4:0] rd;   input [6:0] op;
    begin enc_i = {imm, rs1, f3, rd, op}; end
endfunction

function [31:0] enc_s;
    input [11:0] imm; input [4:0] rs2; input [4:0] rs1;
    input [2:0] f3;   input [6:0] op;
    begin enc_s = {imm[11:5], rs2, rs1, f3, imm[4:0], op}; end
endfunction

function [31:0] enc_b;
    input [12:0] imm; input [4:0] rs2; input [4:0] rs1;
    input [2:0] f3;   input [6:0] op;
    begin enc_b = {imm[12], imm[10:5], rs2, rs1, f3,
                   imm[4:1], imm[11], op}; end
endfunction

function [31:0] enc_j;
    input [20:0] imm; input [4:0] rd; input [6:0] op;
    begin enc_j = {imm[20], imm[10:1], imm[11], imm[19:12], rd, op}; end
endfunction

integer i;

initial begin
    for (i = 0; i < WORDS; i = i + 1)
        rom[i] = `NOP_INST;

    rom[0] = enc_i(12'd5,  5'd0, 3'b000, 5'd1, `OP_OPIMM);
    rom[1] = enc_i(12'd3,  5'd0, 3'b000, 5'd2, `OP_OPIMM);
    rom[2] = enc_r(7'd0,   5'd2, 5'd1,  3'b000, 5'd3, `OP_OP);
    rom[3] = enc_s(12'd0,  5'd3, 5'd0,  3'b010, `OP_STORE);
    rom[4] = enc_i(12'd0,  5'd0, 3'b010, 5'd4, `OP_LOAD);
    rom[5] = enc_r(7'd0,   5'd0, 5'd4,  3'b000, 5'd6, `OP_OP);
    rom[6] = enc_j(21'd8,  5'd5, `OP_JAL);
    rom[7] = `NOP_INST;
    rom[8] = enc_b(13'd0,  5'd0, 5'd0,  3'b000, `OP_BRANCH);
end

always @(*) begin
    rdata = rom[word_addr];
end

endmodule
