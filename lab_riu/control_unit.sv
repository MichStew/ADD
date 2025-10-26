// Michael Stewart and Haley Lind 
module control_unit ( 
  input logic [6:0] opcode, 
  input logic [2:0] funct3, 
  input logic [6:0] funct7, 
  input logic [11:0] csr,
   
  output logic [3:0] aluop, 
  output logic alusrc, 
  output logic [1:0] regsel, 
  output logic regwrite,
  output logic gpio_we
); 
  //default setup 
  always_comb begin 
    aluop = 4'b0000;
    alusrc = 1'b0;
    regsel = 2'b10; 
    regwrite = 1'b0;
    gpio_we = 1'b0;
    
    case(opcode) 
      // R-Type instructions
      7'h33 : begin 
        regwrite = 1'b1; 
        regsel = 2'b10;
        case (funct7) 
          7'h00 : begin 
            case(funct3)
              3'h0 : begin aluop = 4'b0011; end // add
              3'h1 : begin aluop = 4'b1000; end // sll
              3'h2 : begin aluop = 4'b1100; end // slt
              3'h3 : begin aluop = 4'b1101; end // sltu
              3'h4 : begin aluop = 4'b0010; end // xor
              3'h5 : begin aluop = 4'b1001; end // srl
              3'h6 : begin aluop = 4'b0001; end // or
              3'h7 : begin aluop = 4'b0000; end // and
            endcase 
          end
          7'h20 : begin 
            case(funct3) 
              3'h0 : begin aluop = 4'b0100; end // sub
              3'h5 : begin aluop = 4'b1010; end // sra
            endcase
          end 
          7'h01 : begin 
            case(funct3) 
              3'h0 : begin aluop = 4'b0101; end // mul
              3'h1 : begin aluop = 4'b0110; end // mulh
              3'h3 : begin aluop = 4'b0111; end // mulhu
            endcase 
          end
        endcase
      end 
 
      // I-Type instructions
      7'h13 : begin 
        regwrite = 1'b1; 
        alusrc = 1'b1; 
        regsel = 2'b10; 
        case(funct3)
          3'h0 : begin aluop = 4'b0011; end  // addi
          3'h1 : begin aluop = 4'b1000; end  // slli
          3'h2 : begin aluop = 4'b1100; end  // slti (signed)
          3'h3 : begin aluop = 4'b1101; end  // sltiu (unsigned)
          3'h4 : begin aluop = 4'b0010; end  // xori
          3'h6 : begin aluop = 4'b0001; end  // ori
          3'h7 : begin aluop = 4'b0000; end  // andi
          3'h5 : begin 
            if (funct7 == 7'h00) begin 
              aluop = 4'b1001; // srli
            end else begin
              aluop = 4'b1010; // srai
            end 
          end
        endcase
      end
      
      // U-Type instructions
      7'h37 : begin // lui
        regwrite = 1'b1;
        regsel = 2'b01; 
      end 
 
      // CSR instructions
      7'h73 : begin 
        if (funct3 == 3'h1) begin // csrrw
          case(csr)
            12'hf00 : begin // Read from GPIO input
              regwrite = 1'b1;
              regsel = 2'b00; 
            end 
            12'hf02 : begin // Write to GPIO output
              gpio_we = 1'b1;
              regwrite = 1'b0; // Don't write to register when writing to GPIO
            end
            default: begin
              regwrite = 1'b0; // Unknown CSR
            end
          endcase
        end
      end
    endcase
  end
endmodule
