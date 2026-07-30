`timescale 1ns/1ps

module xnor_gate_tb;

reg a, b;
wire y;

xnor_gate dut1 (
    .a(a),
    .b(b),
    .y(y)
);

initial begin

    $dumpfile("xnor_gate.vcd");
    $dumpvars(0, xnor_gate_tb);

    $monitor("Time=%0t a=%b b=%b y=%b",
             $time, a, b, y);

    a = 0; b = 0; #5;
    a = 0; b = 1; #5;
    a = 1; b = 0; #5;
    a = 1; b = 1; #5;

    #10;
    $finish;

end

endmodule
