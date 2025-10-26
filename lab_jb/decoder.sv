// Michael Stewart & Haley Lind 
module decoder (
  input logic [31:0] instruction, 
  
  output logic [6:0] opcode,
  output logic [2:0] funct3, 
  output logic [6:0] funct7, 
  output logic [11:0] csr,
  output logic [4:0] rs1,
  output logic [4:0] rs2,
  output logic [4:0] rd,
  
  output logic [11:0] imm12,
  output logic [31:0] imm20
);
  assign opcode = instruction[6:0];
  assign funct3 = instruction[14:12];
  assign funct7 = instruction[31:25];
  assign csr = instruction[31:20];
  
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign rd = instruction[11:7];
  
  assign imm12 = instruction[31:20]; // I-type immediate
  assign imm20 = {instruction[31:12], 12'b0}; // U-type immediate (pre-shifted)
  
endmodule
