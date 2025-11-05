/*
 * Haley Lind & Michael Stewart
 * CSCE611 RISCV 3 Stage CPU Design
 * Fall 2025
*/

module riscv_32_instr_decoder(
        input logic [31:0] full,

        output logic [6:0] opcode,      // all 
        output logic [2:0] funct3, // 
        output logic [6:0] funct7, // 
        output logic [4:0] rs1,    // 
        output logic [4:0] rs2,    // 
        output logic [4:0] rd,     // dest ... all 
        output logic [11:0] imm12,  // csrrw 
        output logic [19:0] imm20  // u type

        /* We add these because B and J instructions are PC relative */
        output logic [31:0] imm_I, // sign-extended I
        output logic [31:0] imm_U, // upper 20 << 12
        output logic [31:0] imm_B, // sign-extended, includes LSB=0
        output logic [31:0] imm_J  // sign-extended, includes LSB=0

);

assign opcode = full[6:0]; // grabs those bits, which tell opcode
assign funct3 = full[14:12];
assign funct7 = full[31:25]; 
assign rs1 = full[19:15];
assign rs2 = full[24:20];
assign rd = full[11:7];

/* I Type immediate for CSRRW, etc. */
assign imm12 = full[31:20]; //giving syntax error without full & semicolon
/* U type immediate */
assign imm20 = full[31:12];

// --------------------------- FOR LAB 4 ---------------------------

/* Originally the decoder only have I and U which you wcan just bitslice easily , 
using their imm12 or imm20 fields based on the type of opcode (I or U) but we are 
using different addressing now because b and j type instructions are fundamentally 
different and utilize different fields to change cpu settings. */

/* We are adding imm_X for PC-relativity */ 
/* J and B don't give an absolute address, but instead an offset that is added to current PC */
/* Example: pc = 0x1000 and beq has imm_B = 0x000000008, next PC is = 0x1008

// PADDING! sign extends 12 bit value to 32 bits ... 12 bit signed to 32-bit signed number.
assign imm_I  = {{20{full[31]}}, full[31:20]};

// Also Padding!
assign imm_U  = {full[31:12], 12'b0};

logic [12:0] immB13;
assign immB13 = { full[31], full[7], full[30:25], full[11:8], 1'b0 };
assign imm_B  = {{19{immB13[12]}}, immB13};

logic [20:0] immJ21;
assign immJ21 = { full[31], full[19:12], full[20], full[30:21], 1'b0 };
assign imm_J  = {{11{immJ21[20]}}, immJ21};

endmodule
