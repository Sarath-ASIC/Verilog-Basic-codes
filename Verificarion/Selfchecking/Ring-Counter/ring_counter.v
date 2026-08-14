`timescale 1ns/1ps

module ring_counter ( input clk, rst,
                      output reg [3:0] ring_out
                      );
                      
                      always @(posedge clk or posedge rst) 
                      begin
                      if (rst)
                      ring_out <= 4'b0001;
                      else 
                      ring_out <= { ring_out[2:0] , ring_out[3] };
                      end
                      
                      endmodule
                      
