// haley lind & Michael Stewart csce611 oct15 2025
// needs to be named the same as the file 
module cpu(
    input logic clk, 
    input logic res, // named res, needs to match below 
    input logic [17:0] gpio_in,
    output logic [17:0] gpio_out
);

    // 3 stages ... 1. fetch, 2. execute, 3. writeback

    // read an assembled riscv program via instmem.dat (this is for testing) and reset the CPU
    // 
    
    
    // [PC] -> [Instruction Memory] -> [Instruction Register]

    /* FETCH STAGE */
    // need to declare instruction fields still 
    logic [6:0] opcode; 
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rs1, rs2, rd;
    logic [11:0] imm12;
    logic [19:0] imm20;
    
    //control signals
    logic [1:0] alusrc_EX;
    logic [0:0] GPIO_we; 
    logic [0:0] regwrite_EX;
    logic [1:0] regsel_EX;
    logic [3:0] aluop_EX;
    
    //register file signals 
    logic [31:0] readdata1, readdata2; 
    logic [31:0] writedata;
    
    // ALU signals 
    logic [31:0] alu_A, alu_B, alu_result; 
    logic alu_zero;
    
    //GPIO registers
    logic [31:0] gpio_out_reg;
    
    
    
    logic [31:0] pc_F, pc_next_F;
    logic [31:0] instruction_F;

    // instruction memory
        // also where PC might live? based on CPU diagram
        // logic 31 instruction_mem 4095:0 
        // logic 31 instruction_ex 
        // instr_mem imem (
    //     .clk (clk),
    //     .addr(pc_F),
    //     .data(instruction_F)        // valid next cycle
    // );

    // "initializing instruction memory" from slides
    logic [31:0] instruction_mem [4095:0];
    logic [31:0] instruction_EX;
    //needs to follow naming of compiled rars program 
    initial $readmemh("instmem.dat", instruction_mem);

    always_ff @(posedge clk)
        if (res) begin
        instruction_EX <= 32'b0;
        pc_F <= 32'b0;
        end else begin
        instruction_EX <= instruction_mem[pc_F[11:2]];
        pc_F <= pc_F + 32'd4;
        end

	riscv_32_instr_decoder decode (

            .full(instruction_EX),
            .opcode(opcode),
            
            .funct3(funct3),
            .funct7(funct7),
            
            .rs1(rs1),
            .rs2(rs2),
            .rd(rd),

            .imm12(imm12),
            .imm20(imm20)
            // .type_of_instruction(type_of_instruction) // no mas
    );

    //We wire the control unit to above wires declared in "Control unit wiring" section
    ctrl_unit ctrl (
            .op(opcode),
            .funct3(funct3),
            .funct7(funct7),
            .imm12(imm12),
            .imm20(imm20), 

            /* outputs */
            .alusrc_EX(alusrc_EX),     
            .GPIO_we(GPIO_we),
            .regwrite_EX(regwrite_EX),
            .regsel_EX(regsel_EX), // 1 bit
            .aluop_EX(aluop_EX) // isn't that four bits*/
    );
    
    regfile rf (
    .clk(clk),
    .we(regwrite_EX),
    .readaddr1(rs1),
    .readaddr2(rs2),
    .writeaddr(rd),
    .writedata(writedata),
    .readdata1(readdata1),
    .readdata2(readdata2)
    );
    
    alu alu_inst ( 
    .A(alu_A),
    .B(alu_B),
    .op(aluop_EX),
    .R(alu_result),
    .zero(alu_zero)
    );
    
    assign alu_A = readdata1;
    always_comb begin
    	case(alusrc_EX)
    		2'b00: alu_B = readdata2; // R type use rs2
    		2'b01: alu_B = {{20{imm12[11]}}, imm12}; // I type 
    		2'b10: alu_B = {imm20, 12'b0};
    	default: alu_B = 32'b0;
    	endcase
    end 
    
    //Select what data to write back to register file 
    always_comb begin 
    	case(regsel_EX)
    		2'b00: writedata = 32'b0; // Default 
    		2'b01: writedata = {imm20, 12'b0}; // write immediate 
    		2'b10: writedata = gpio_in;  // Normal: write ALU result 
    		2'b11: writedata = gpio_in; // CSRRW read: write GPIO input 
    		default: writedata = 32'b0;
    	endcase
    end
    
   // GPIO output register f00 
   always_ff @(posedge clk) begin 
   	if (res) begin
   		gpio_out_reg <= 32'b0;
   	end else if (GPIO_we) begin 
   		gpio_out_reg <= readdata1; // write rs1 to GPIO
   	end
   end 
   assign gpio_out = gpio_out_reg; 
    		 
endmodule
