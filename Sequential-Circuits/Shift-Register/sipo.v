`timescale 1ns/1ps

module sipo_sr( input s_in, clk,
                output [3:0] s_out
                );
                
                reg [3:0] shift_regester = 4'b0000; 
                assign s_out  = shift_regester;
                
                always @(posedge clk)
                begin
                shift_regester <= { shift_regester[2:0], s_in};
                end
                
                endmodule
                
                
                
