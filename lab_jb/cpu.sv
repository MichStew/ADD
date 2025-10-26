// Haley Lind & Michael Stewart 
// cpu file 
module cpu ( 
  input logic clk, 
  input logic rst, //active low reset 
  input logic [31:0] gpio_in, // 32 bit, needs padded in top 
  output logic [31:0] gpio_out
);
// all the junk we need for this cpu to finally freaking work 
  logic [31:0] PC_FETCH;
  logic [31:0] instruction_EX;
  logic [6:0] opcode_EX; 
  logic [2:0] funct3_EX; 
  logic [6:0] funct7_EX;
  logic [11:0] csr_EX;
  logic [4:0] rs1_EX, rs2_EX, rd_EX; 
  logic [11:0] imm12_EX; 
  logic [31:0] imm20_EX;
  
  logic [3:0] aluop_EX; 
  logic alusrc_EX; 
  logic [1:0] regsel_EX, regsel_WB; 
  logic regwrite_EX, regwrite_WB;
  logic gpio_we; 
  
  logic [31:0] readdata1; 
  logic [31:0] readdata2; 
  logic [31:0] writedata_WB;
  logic [4:0] rd_WB;
  
  logic [31:0] A, B; // used in the alu 
  logic [31:0] R_EX, R_WB; // read execute and write 
  logic zero; 
  
  logic [31:0] imm_extended; 
  logic [31:0] shiftE;
  logic [31:0] shifty; 
  logic pr;
  logic [31:0] imm20_WB;
  
  // assigns needed for this to work properly   
  assign A = readdata1; 
  assign shiftE = {{20{imm12_EX[11]}}, imm12_EX};
  assign shifty = {27'b0, imm12_EX[4:0]}; 
  assign pr = (rd_WB == 5'd0) ? 1'b0 : regwrite_WB;
  
  always_ff @(posedge clk) begin
    if (!rst) begin 
      PC_FETCH <= 32'd0; // we want decimal, and also to read after the clk so we dont have timing issue 
    end else begin 
      PC_FETCH <= PC_FETCH + 1;
    end 
  end 
  
  logic [31:0] imem[0:255]; //32 bits of 256 bit memory
  assign instruction_EX = imem[PC_FETCH];
  
  // was having issues here for a LONG time
  // read file 
  initial begin 
    $readmemh("./instmem.dat",imem);
  end 
  
  // instantiate decoder for instruction 
  decoder mydecode (
    .instruction(instruction_EX),
    .opcode(opcode_EX),
    .funct3(funct3_EX),
    .funct7(funct7_EX),
    .csr(csr_EX), 
    .rs1(rs1_EX),
    .rs2(rs2_EX),
    .rd(rd_EX),
    .imm12(imm12_EX),
    .imm20(imm20_EX)
); 
  // instantiate control unit 
  control_unit runner ( 
  .opcode(opcode_EX),
  .funct3(funct3_EX),
  .funct7(funct7_EX),
  .csr(csr_EX),
  .aluop(aluop_EX),
  .alusrc(alusrc_EX),
  .regsel(regsel_EX),
  .regwrite(regwrite_EX), 
  .gpio_we(gpio_we)
);
  // instantiate regfile 
  regfile rf ( 
    .clk(clk),
    .we(pr), 
    .readaddr1(rs1_EX), 
    .readaddr2(rs2_EX), 
    .writeaddr(rd_WB), 
    .writedata(writedata_WB), 
    .readdata1(readdata1),
    .readdata2(readdata2)
);
  always_comb begin 
    if(alusrc_EX) begin 
      if(aluop_EX == 4'b1000 || aluop_EX == 4'b1001 || aluop_EX == 4'b1010) begin 
        B = shifty;
      end else begin 
        B = shiftE; 
      end 
    end else begin 
      B = readdata2;
    end
  end 
  
  // instantiate the ALU that we were given 
  alu go ( 
  .A(A),
  .B(B),
  .op(aluop_EX),
  .R(R_EX),
  .zero(zero) 
);
  always_ff @(posedge clk) begin 
    if (!rst) begin 
      R_WB <= 32'd0;
      rd_WB <= 5'd0;
      regwrite_WB <= 1'b0;
      regsel_WB <= 2'b00; 
      imm20_WB <= 32'd0;
    end else begin 
      R_WB <= R_EX;
      rd_WB <= rd_EX;
      regwrite_WB <= regwrite_EX; 
      regsel_WB <= regsel_EX;
      imm20_WB <= imm20_EX;
    end
  end 
  
  //writeback mux, like the diagram from the test lol 
  always_comb begin 
    case (regsel_WB) 
      2'b00 : writedata_WB = gpio_in;
      2'b01 : writedata_WB = imm20_WB;
      2'b10 : writedata_WB = R_WB; 
      default : writedata_WB = 32'd0; 
    endcase 
  end 
  
  // if reset is pressed hex should display all 0 
  always_ff @(posedge clk) begin 
    if (!rst) begin 
      gpio_out <= 32'd0; 
    end else if (gpio_we) begin 
      gpio_out <= readdata1; 
    end 
  end 
endmodule
