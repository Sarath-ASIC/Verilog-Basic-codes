`timescale 1ns/1ps

module dflop_async_rst(  input d, clk, rst,
                         output reg q ,
                         output qbar
                         );
                         
                         assign qbar =~q;
                         //active high rst
                         always @(posedge clk or posedge rst )
                         begin
                         
                         if (rst) 
                         q = 1'b0;
                         else 
                         q <= d;
                         
                         end
                         endmodule
