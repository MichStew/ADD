/*
 * Haley Lind & Michael Stewart
 * CSCE611 RISCV 3 Stage CPU Design
 * Fall 2025
 *
 * This is the brain of the CPU. It looks at opcode, funct3, funct7,
 * and imm12 fields from an instruction and decides what control signals
 * to send to other parts of the CPU.
 */

module ctrl_unit(
    input logic [6:0] op,       // opcode from instruction decoder
    input logic [2:0] funct3,   // funct3 field
    input logic [6:0] funct7,   // funct7 field
    input logic [11:0] imm12,   // immediate for CSR/GPIO instructions
    input logic [19:0] imm20,
    output logic [1:0] alusrc_EX,
    output logic GPIO_we,
    output logic regwrite_EX,
    output logic [1:0] regsel_EX,
    output logic [3:0] aluop_EX
);

    always_comb begin
        // -------------------- Setting defaults --------------------
        regwrite_EX = 1'b0;
        alusrc_EX   = 2'b00;
        GPIO_we     = 1'b0;
        regsel_EX   = 2'b00;
        aluop_EX    = 4'b0000;

        case(op)
            // -------------------- R TYPE --------------------
            7'b0110011: begin
                regwrite_EX = 1'b1;
                alusrc_EX   = 2'b00;
                regsel_EX   = 2'b10;
                GPIO_we     = 1'b0;

                if (funct7 == 7'b0000000) begin
                    if      (funct3 == 3'b000) aluop_EX = 4'b0011; // ADD
                    else if (funct3 == 3'b100) aluop_EX = 4'b0001; // XOR
                    else if (funct3 == 3'b110) aluop_EX = 4'b0000; // OR
                    else if (funct3 == 3'b111) aluop_EX = 4'b0000; // AND
                    else if (funct3 == 3'b001) aluop_EX = 4'b0101; // SLL
                    else if (funct3 == 3'b101) aluop_EX = 4'b0110; // SRL
                    else if (funct3 == 3'b010) aluop_EX = 4'b1000; // SLT
                    else if (funct3 == 3'b011) aluop_EX = 4'b1001; // SLTU
                end
                else if (funct7 == 7'b0100000) begin
                    if (funct3 == 3'b000) aluop_EX = 4'b0100; // SUB
                    else if (funct3 == 3'b101) aluop_EX = 4'b0111; // SRA
                end
                else if (funct7 == 7'b0000001) begin
                    if      (funct3 == 3'b000) aluop_EX = 4'b1010; // MUL
                    else if (funct3 == 3'b001) aluop_EX = 4'b1011; // MULH
                    else if (funct3 == 3'b010) aluop_EX = 4'b1100; // MULHSU
                    else if (funct3 == 3'b011) aluop_EX = 4'b1101; // MULHU
                    else if (funct3 == 3'b100) aluop_EX = 4'b1110; // DIV
                    else if (funct3 == 3'b101) aluop_EX = 4'b1110; // DIVU
                    else if (funct3 == 3'b110) aluop_EX = 4'b1111; // REM
                    else if (funct3 == 3'b111) aluop_EX = 4'b1111; // REMU
                end
            end

            // -------------------- I TYPE --------------------
            7'b0010011: begin
                regwrite_EX = 1'b1;
                alusrc_EX   = 2'b01;
                regsel_EX   = 2'b10;
                GPIO_we     = 1'b0;

                if      (funct3 == 3'b000) aluop_EX = 4'b0011; // ADDI
                else if (funct3 == 3'b001) aluop_EX = 4'b0101; // SLLI
                else if (funct3 == 3'b011) aluop_EX = 4'b1001; // SLTIU
                else if (funct3 == 3'b100) aluop_EX = 4'b0001; // XORI
                else if (funct3 == 3'b101) aluop_EX = 4'b0110; // SRLI
                else if (funct3 == 3'b110) aluop_EX = 4'b0010; // ORI
                else if (funct3 == 3'b111) aluop_EX = 4'b0000; // ANDI
            end

            // -------------------- U TYPE (LUI) --------------------
            7'b0110111: begin
                regwrite_EX = 1'b1;
                alusrc_EX   = 2'b10;
                regsel_EX   = 2'b01;
                GPIO_we     = 1'b0;
                aluop_EX    = 4'b0000;
            end

            // -------------------- CSRRW --------------------
            7'b1110011: begin
                regwrite_EX = 1'b0;
                alusrc_EX   = 2'b00;
                regsel_EX   = 2'b00;
                aluop_EX    = 4'b0000;

                if (imm12 == 12'hF00) begin
                    GPIO_we     = 1'b1;
                    regwrite_EX = 1'b0;
                end
                else if (imm12 == 12'hF02) begin
                    GPIO_we     = 1'b0;
                    regwrite_EX = 1'b1;
                    regsel_EX   = 2'b11;
                end
                else begin
                    GPIO_we = 1'b0;
                end
            end

            // -------------------- DEFAULT --------------------
            default: begin
                regwrite_EX = 1'b0;
                alusrc_EX   = 2'b00;
                GPIO_we     = 1'b0;
                regsel_EX   = 2'b00;
                aluop_EX    = 4'b0000;
            end
        endcase
    end

endmodule

