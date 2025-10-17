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

	SW = 18'b0;
	$display("======================================");
	$display("Starting CPU test");
	$display("---------------------------------------");
	
	
	$display("\n Test 1: Instruction Fetch");
	#100 // supposed to run for 10 clock cycles
	$display("PC= %h", "dut.mycpu.pc_F");
	$display("finish this junk later lol.");
	
	repeat(20) begin 
	#10
	$display("%0t\t%h\t%h\t\t%h", $time, dut.mycpu.pc_F,
	dut.mycpu.instruction_EX, dut.mycpu.rf.mem[5]);
	end 
	// Check output 
	$display("\n Final Ouput");
	$display("GPIO Output (0xF00) = %d (decimal) = %h (hex)",
	dut.gpio_out, dut.gpio_out);
	if (dut.gpio_out == 32'hC0000000) begin 
	  $display("test passed");
	end else begin 
	  $display("test failed");
end 








