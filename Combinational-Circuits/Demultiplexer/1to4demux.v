`timescale 1ns/1ps

module demux_1_to_4 (

    input       in,
    input [1:0] s,
    output reg [3:0] y

);

always @(*) begin

    // Default: all outputs LOW
    y = 4'b0000;

    case(s)

        2'b00 : y[0] = in;

        2'b01 : y[1] = in;

        2'b10 : y[2] = in;

        2'b11 : y[3] = in;

    endcase

end

endmodule
