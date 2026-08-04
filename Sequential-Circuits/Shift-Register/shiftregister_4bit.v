`timescale 1ns/1ps

module register_4bit( input [3:0] d, 
                      input clk, 
                      output reg [3:0] q
                      );
                      
                      always @(posedge clk)
                      begin
                      
                      q <= d;
                      
                      end 
                      endmodule 
