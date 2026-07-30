`timescale 1ns/1ps

module xor_sim;

reg a, b;
wire y;

xor_gate dut1 (
    .a(a),
    .b(b),
    .y(y)
);

initial begin
    a = 0;
    b = 0;
end

initial begin
    $dumpfile("xorgate.vcd");
    $dumpvars(0, xor_sim);

    $monitor("Time=%0t a=%b b=%b y=%b",
             $time, a, b, y);

    a = 0; b = 0; #5;
    a = 0; b = 1; #5;
    a = 1; b = 0; #5;
    a = 1; b = 1; #5;

    #20;
    $finish;
end

endmodule
