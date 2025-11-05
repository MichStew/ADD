/* verilog testing suite for cpu 
haley lind and michael Stewart
csce611 dr jason bakos
advanced digital logic design */

/*
We had two options to approach the test bench: 
    1. hex encoding for expected output (if doing top as dut)        
    2. tb instance cpu not entire top (if cpu is dut)
*/

module test_suite;

// device under testing
	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;

    // device under testing (CPU)
	cpu dut(        // we choose to directly test cpu at dut because testing top just seems like its adding additional noise at this opint
        .clk(clk), 
        .res(res), 
        gpio_in(SW),
        gpio_out() // ????
    );

initial begin
	
    // to validate if control unit produces correct or errorful results
    
    
end	

endmodule