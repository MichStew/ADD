// Haley Lind & Michael Stewart
module regfile ( 
  input clk, 
  input we, 
  input [4:0] readaddr1, 
  input [4:0] readaddr2, 
  input [4:0] writeaddr, 
  input [31:0] writedata, 
  
  output logic [31:0] readdata1,
  output logic [31:0] readdata2
); 
  logic [31:0] memory[31:0]; 
  
  always_ff @(posedge clk) begin 
    if (we) memory[writeaddr] <= writedata;
  end 
  
  always_comb begin 
    if (readaddr1 == 5'd0) readdata1 = 32'd0;
    else if (we && readaddr1 == writeaddr) readdata1 = writedata; 
    else readdata1 = memory[readaddr1];
    
    if (readaddr2 == 5'd0) readdata2 = 32'd0; 
    else if (we && readaddr2 == writeaddr) readdata2 = writedata;
    else readdata2 = memory[readaddr2];
  end 
endmodule
