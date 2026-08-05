`timescale 1ns/1ps

module usr ( input clk,
             input [3:0] d,
             input [1:0] mode_sel,
             input shift_right, shift_left,
             output reg [3:0] q
             );
             
             always @(posedge clk)
             begin
             case (mode_sel)
             2'b00: q <=q;
             
             2'b01: q <= {shift_right, q[3:1]};
             
             2'b10: q<= {q[2:0] ,shift_left} ;
             
             2'b11: q <= d;
             
             default: q<=q;
             
             endcase
             end
             endmodule
             
