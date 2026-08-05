`timescale 1ns/1ps

module ripple_counter ( input clk, rst,
                        output reg[3:0] q
                        );
                        
                        always@(posedge clk or posedge rst)
                        begin
                        if(rst)
                        q <= 4'b0000;
                        else
                        q <= q+ 1'b1;
                        end
                        endmodule
