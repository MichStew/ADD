// Michael Stewart & Haley Lind
module top ( 
  input CLOCK_50, 
  input CLOCK2_50, 
  input CLOCK3_50, 
  input [3:0] KEY, 
  input [17:0] SW, 
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5,
  output [6:0] HEX6,
  output [6:0] HEX7
);

  logic [31:0] bridge;
  
  cpu mycpu(
    .clk(CLOCK_50), 
    .rst(KEY[0]),
    .gpio_in({14'b0, SW}), // pad them switches with 14 0's 
    .gpio_out(bridge)
  );
  
  hexdriver hex0 (.val(bridge[3:0]), .HEX(HEX0));   
  hexdriver hex1 (.val(bridge[7:4]), .HEX(HEX1));   
  hexdriver hex2 (.val(bridge[11:8]), .HEX(HEX2));   
  hexdriver hex3 (.val(bridge[15:12]), .HEX(HEX3));   
  hexdriver hex4 (.val(bridge[19:16]), .HEX(HEX4));   
  hexdriver hex5 (.val(bridge[23:20]), .HEX(HEX5));   
  hexdriver hex6 (.val(bridge[27:24]), .HEX(HEX6));   
  hexdriver hex7 (.val(bridge[31:28]), .HEX(HEX7));   
  
endmodule
