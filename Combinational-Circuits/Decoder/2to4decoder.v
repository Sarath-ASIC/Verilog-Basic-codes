`timescale 1ns/1ps

module decoder2_4( input [1:0] i,
                   output reg [3:0] y
                   );
                   
                   always @(*) begin
                   case(i)
                   
                   2'b00: y= 4'b0000;
                   2'b01: y= 4'b0010;
                   2'b10: y= 4'b0100;
                   2'b11: y= 4'b1000;
                   
                   endcase
                   end
                   endmodule
