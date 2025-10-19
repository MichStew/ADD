module simtop;

    logic clk;
    logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
    logic [3:0] KEY;
    logic [17:0] SW;

    top dut
    (
        // CLOCK
        .CLOCK_50(clk),
        .CLOCK2_50(),
        .CLOCK3_50(),

        // LED
        .LEDG(),
        .LEDR(),

        // KEY and SW
        .KEY(KEY),
        .SW(SW),

        // SEG7
        .HEX1(HEX1),
        .HEX0(HEX0),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7)
    );

    // ---------------- Clock generator ----------------
    initial clk = 0;
    always #5 clk = ~clk; // 10 time units per full period

    initial begin
        // Start conditions
        SW = 18'b0;
        // KEY: default not-pressed = 1 (DE2 buttons are active-low typically)
        KEY = 4'b1111;

        $display("======================================");
        $display("Starting CPU test");
        $display("---------------------------------------");

        // Optional: apply a short reset pulse (press KEY0 for a few cycles)
        KEY[0] = 1'b0; // press (active-low)
        #20;
        KEY[0] = 1'b1; // release -> cpu.res = ~KEY0 will be 0 (not in reset)
        #20;

        $display("\n Test 1: Instruction Fetch (show PC and instruction_EX)");
        #100; // let a few cycles run

        $display("PC= %h", dut.my_cpu.pc_F);
        $display("Instruction_EX = %h", dut.my_cpu.instruction_EX);

        repeat (60) begin
            #10; // wait one clock period (since clk toggles every 5)
            $display("%0t\tPC=%h\tINSTR=0x%08h\tRF[5]=0x%08h GPIO_in=0x%08h GPIO_out=0x%08h GPIO_we=%b",
                     $time,
                     dut.my_cpu.pc_F,
                     dut.my_cpu.instruction_EX,
                     dut.my_cpu.rf.mem[5],
                     dut.my_cpu.gpio_in,
                     dut.my_cpu.gpio_out_reg,
                     dut.my_cpu.GPIO_we);
        end

        // Simple final check print
        $display("\n Final Ouput");
        $display("GPIO Output  = 0x%08h (dec %0d)",
                 dut.my_cpu.gpio_out, dut.my_cpu.gpio_out);

        $finish;
    end

endmodule

