`timescale 1ns/1ps

module sr_latch ( input s,r,clk,
                  output reg q, 
                  output qbar
                  );
                  assign qbar = ~q;
                  
                  always@(*) begin
                  case({s,r})
                  
                  2'b00 : q=q;
                  2'b01 : q=1'b0;
                  2'b10 : q= 1'b1;
                  2'b11 : q= 1'bx;
                  
                  endcase
                  end 
                  endmodule
