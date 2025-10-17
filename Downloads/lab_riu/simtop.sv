/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

        logic clk;
        logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
        logic [3:0] KEY;
        logic [17:0] SW;

        top dut
        (
                //////////// CLOCK //////////
                .CLOCK_50(clk),
                .CLOCK2_50(),
                .CLOCK3_50(),

                //////////// LED //////////
                .LEDG(),
                .LEDR(),

                //////////// KEY //////////
                .KEY(KEY),

                //////////// SW //////////
                .SW(SW),

                //////////// SEG7 //////////
                .HEX1(HEX1),
                .HEX0(HEX0),
                .HEX2(HEX2),
                .HEX3(HEX3),
                .HEX4(HEX4),
                .HEX5(HEX5),
                .HEX6(HEX6),
                .HEX7(HEX7)
        );

        initial begin

                /* THE BELOW IS ALL CODE FROM LAB 2, A TESTBENCH I CREATED AND WILL BE USED AS --- REFERENCE --- FOR LAB 3*/
                /* Demo for 7seg 0 */
                SW = 18'b0000_0000_0000_0000_01; #10 // sets switch, then delay or 5 seconds
                if(HEX0 == 7'b1111001) $display("Testcase 1 passed");
                SW = 18'b0000_0000_0000_0010_00; #10 // sets switch, then delay or 5 seconds
                if(HEX0 == 7'b0000000) $display("Testcase 2 passed");
                
                /* dEMO FOR 7seg 1 */
                SW = 18'b0000_0000_0000_0100_00; #10 // sets switch, then delay or 5 seconds
                if(HEX1 == 7'b1111001) $display("Testcase 3 passed");
                SW = 18'b0000_0000_0010_0000_00; #10 // sets switch, then delay or 5 seconds
                if(HEX1 == 7'b0000000) $display("Testcase 4 passed");
                
                /* Demo for 7seg 2  */
                SW = 18'b0000_0000_1100_0000_00; #10 // sets switch, then delay or 5 seconds
                if(HEX2 == 7'b0110000) $display("Testcase 5 passed");
                SW = 18'b0000_0000_01_0000_0000; #10 // sets switch, then delay or 5 seconds
                if(HEX2 == 7'b1111001) $display("Testcase 6 passed");
                
                /* Demo for 7seg 3 */
                SW = 18'b00_0001_0000_0000_0000; #10 // sets switch, then delay or 5 seconds
                if(HEX3 == 7'b1111001) $display("Testcase 7 passed");
                SW = 18'b0001_0000_0000_0000_00; #10 // sets switch, then delay or 5 seconds
                if(HEX3 == 7'b0011001) $display("Testcase 8 passed");
                
                /* Demo for 7seg 4 */
                SW = 18'b1100_0000_0000_0000_00; #10 // sets switch, then delay or 5 seconds
                if(HEX4 == 7'b0110000) $display("Testcase 9 passed");
                SW = 18'b1000_0000_0000_0000_00; #10 // sets switch, then delay or 5 seconds
                if(HEX4 == 7'b0100100) $display("Testcase 10 passed");
        
		
	end

        // pulse reset (active low)
        initial begin
                KEY <= 4'he;
                #10;
                KEY <= 4'hf;
        end

        // drive clock
        always begin
                clk <= 1'b0; #5;
                clk <= 1'b1; #5;
        end

        // assign simulated switch values
        assign SW = 18'd12345;

endmodule

// need to update actual architecture to reflect the cpu but this is good pseudo code 
Initial begin 
// instantiate our testbench, needs to check the output of the cpu. binary numbers need to output decimal numbers, really just check those 
//set switches to desired numbers to check 
SW = 18'h1dddd;  // this is 18 bits that, we are assigning 4 to every 4 bit section in the 18, we will check the 

// need to take the input from the risc v code and read after some number of cyclces to check if we are correct 
#20
if (HEX0 !== 0xf00) begin 
	$display("yo junk is cooked for //initial number) 
end else $display("looking good for TEST CASE) 
if (HEX1 !-- 0xf00)
	$display("not working for input 4") 
end else $display("looking good for 4")
end 
//testing, needs to be longer 

// make it clock constantly
// display statements inside the cpu to output after instruction 
// chech csrrw with the output 
// always_ff @ (posedge clk) 
// if (rst) begin 
// instruction_EX <= 32'b0;
//PC_FETCH <= instruction_mem[PC_FETCH];
//end 











