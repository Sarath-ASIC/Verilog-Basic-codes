`timescale 1ns/1ps

module d_latch (

    input D,
    input EN,

    output reg Q,
    output Qbar

);

assign Qbar = ~Q;

always @(*) begin

    if (EN)

        Q = D;

    // No else because , 
    // else
    //    q=0;  //a beginner mistake - the basic usage fo latch is to hold the state no need to set/ become 0 in any scenario

end

endmodule
