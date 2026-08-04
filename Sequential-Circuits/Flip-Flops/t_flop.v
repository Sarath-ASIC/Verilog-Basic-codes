`timescale 1ns/1ps

module t_flipflop(

    input clk,
    input t,

    output reg q,
    output qbar

);

assign qbar = ~q;

always @(posedge clk)
begin

    if(t)

        q <= ~q;

    else

        q <= q;

end

endmodule
