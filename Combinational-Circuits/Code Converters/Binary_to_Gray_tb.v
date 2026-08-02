`timescale 1ns/1ps

module binary_to_gray_tb;

reg  [3:0] bin;
wire [3:0] gray;

binary_to_gray dut(
    .bin(bin),
    .gray(gray)
);

initial begin

    $dumpfile("binary_to_gray.vcd");
    $dumpvars(0, binary_to_gray_tb);

    $monitor("Time=%0t Binary=%b Gray=%b",
              $time, bin, gray);

    bin = 4'b0000; #5;
    bin = 4'b0001; #5;
    bin = 4'b0010; #5;
    bin = 4'b0011; #5;
    bin = 4'b0100; #5;
    bin = 4'b0101; #5;
    bin = 4'b0110; #5;
    bin = 4'b0111; #5;
    bin = 4'b1000; #5;
    bin = 4'b1001; #5;
    bin = 4'b1010; #5;
    bin = 4'b1011; #5;
    bin = 4'b1100; #5;
    bin = 4'b1101; #5;
    bin = 4'b1110; #5;
    bin = 4'b1111; #5;

    $finish;

end

endmodule
