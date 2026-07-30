`timescale 1ns/1ps

module tb_mux4to1;

reg  [3:0] I;
reg  [1:0] S;
wire Y;

// Instantiate the DUT
mux4to1 uut (
    .I(I),
    .S(S),
    .Y(Y)
);

initial begin
    // Display header
    $display("Time\tI\tS\tY");
    $monitor("%0t\t%b\t%b\t%b", $time, I, S, Y);

    // Test Case 1
    I = 4'b1010;

    S = 2'b00; #10;
    S = 2'b01; #10;
    S = 2'b10; #10;
    S = 2'b11; #10;

    // Test Case 2
    I = 4'b1101;

    S = 2'b00; #10;
    S = 2'b01; #10;
    S = 2'b10; #10;
    S = 2'b11; #10;

    $finish;
end

endmodule
