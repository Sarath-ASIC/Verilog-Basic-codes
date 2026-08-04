`timescale 1ns/1ps

module d_flop( input d, clk, rst,
               output reg q,
               output q_bar
               );
               
               assign q_bar = ~q;
               
               always@(posedge clk)
               begin
               if(rst)
               q <= 1'b0;
               
               else 
               q <= d;
               end
               endmodule
