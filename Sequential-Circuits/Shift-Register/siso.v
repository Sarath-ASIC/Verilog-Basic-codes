`timescale 1ns/1ps

module siso_sr( input s_in, clk,
                 output s_out
                 );
                 
                 reg[3:0] shift_register; //shift register bank creation
                 
                 assign s_out = shift_register[3];   // This single line performs the entire shift operation.
                 
                 always @(posedge clk) 
                 begin
                 
                 shift_register <= {shift_register[2:0], s_in};
                 
                 end
                 
                 endmodule
