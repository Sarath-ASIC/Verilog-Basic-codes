`timescale 1ns/1ps

module full_subtractor_tb;

reg a, b, bin;
wire diff, bout;

// DUT
full_subtractor dut(
    .a(a),
    .b(b),
    .bin(bin),
    .diff(diff),
    .bout(bout)
);

initial begin

    $dumpfile("full_subtractor.vcd");
    $dumpvars(0, full_subtractor_tb);

    $monitor("Time=%0t a=%b b=%b bin=%b diff=%b bout=%b",
              $time, a, b, bin, diff, bout);

    a=0; b=0; bin=0; #5;
    a=0; b=0; bin=1; #5;
    a=0; b=1; bin=0; #5;
    a=0; b=1; bin=1; #5;
    a=1; b=0; bin=0; #5;
    a=1; b=0; bin=1; #5;
    a=1; b=1; bin=0; #5;
    a=1; b=1; bin=1; #5;

    #10;
    $finish;

end

endmodule
