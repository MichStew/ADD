// Michael Stewart & Haley Lind 
module simtop;

  logic clk;
  logic [17:0] SW;
  logic [3:0]  KEY;
  logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
  logic CLOCK2_50, CLOCK3_50;
  logic [31:0] expected_out;

  // Instantiate DUT
  top dut (
    .CLOCK_50(clk),
    .CLOCK2_50(CLOCK2_50),
    .CLOCK3_50(CLOCK3_50),
    .KEY(KEY),
    .SW(SW),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .HEX6(HEX6),
    .HEX7(HEX7)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Helper: binary to "decimal digit hex" 
  function automatic logic [31:0] bin_to_decimal_hex(int value);
    logic [3:0] d0, d1, d2, d3;
    int temp;
    begin
      temp = value;
      d0 = temp % 10; temp = temp / 10;
      d1 = temp % 10; temp = temp / 10;
      d2 = temp % 10; temp = temp / 10;
      d3 = temp % 10;
      bin_to_decimal_hex = {20'b0, d3, d2, d1, d0};
    end
  endfunction

  // Test sequence: pick a few known switch values
  initial begin
    KEY = 4'b1111;
    $display("=== RISC-V CPU binary→hex conversion test ===");

    // ---- Test case 1 ----
    SW = 18'd42; // binary 42
    KEY = 4'b1110; #20; KEY = 4'b1111; // reset pulse
    repeat (100) @(posedge clk);
    expected_out = bin_to_decimal_hex(SW);
    $display("SW=%0d | expected gpio_out=0x%0h | got=0x%0h", // information that tells us what was in gpio, superuseful for the debug 
             SW, expected_out, dut.mycpu.gpio_out);
    if (dut.mycpu.gpio_out == expected_out)
      $display("PASS ");
    else
      $display("its cooked bro ");

    // ---- Test case 2 ----
    SW = 18'd123;
    KEY = 4'b1110; #20; KEY = 4'b1111;
    repeat (100) @(posedge clk);
    expected_out = bin_to_decimal_hex(SW);
    $display("SW=%0d | expected gpio_out=0x%0h | got=0x%0h", 
             SW, expected_out, dut.mycpu.gpio_out);
    if (dut.mycpu.gpio_out == expected_out)
      $display("test passed");
    else
      $display("its cooked bro ");

    // ---- Test case 3 ----
    SW = 18'd999;
    KEY = 4'b1110; #20; KEY = 4'b1111;
    repeat (100) @(posedge clk);
    expected_out = bin_to_decimal_hex(SW);
    $display("SW=%0d | expected gpio_out=0x%0h | got=0x%0h", 
             SW, expected_out, dut.mycpu.gpio_out);
    if (dut.mycpu.gpio_out == expected_out)
      $display("test passed");
    else
      $display("didn't work, ensure switches are set properly ");

    $display("=== Test complete ===");
    $finish;
  end

endmodule

