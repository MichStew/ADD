module hexdriver (input [3:0] val, output logic [6:0] HEX);
always_comb begin
    case (val) // constructor, gets called from ctrl
      4'd0: HEX = 7'b1000000;
      4'd1: HEX = 7'b1111001;
      4'd2: HEX = 7'b0100100;
      4'd3: HEX = 7'b0110000;
      4'd4: HEX = 7'b0011001;
      4'd5: HEX = 7'b0010010;
      4'd6: HEX = 7'b0000010;
      4'd7: HEX = 7'b1111000;
      4'd8: HEX = 7'b0000000;
      4'd9: HEX = 7'b0011000;
      /* how to activate 2 ??? */
      4'd10: HEX = 7'b0001000;    
      4'd11: HEX = 7'b0000011;
      4'd12: HEX = 7'b1000110;
      4'd13: HEX = 7'b0100001;
      4'd14: HEX = 7'b0000110;
      4'd15: HEX = 7'b0001110;
      default: HEX = 7'b1111111;
    endcase
  end
  

endmodule
