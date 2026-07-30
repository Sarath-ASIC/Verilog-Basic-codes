`timescale 1ns/1ps

module xnor_gate (
    input  a,
    input  b,
    output y
);

assign y = ~(a ^ b);
// Alternatively:
// assign y = a ~^ b;

endmodule
