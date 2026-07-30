`timescale 1ns/1ps

module tb_encoder4to2;

reg  [3:0] I;
wire [1:0] Y;

// Instantiate DUT
encoder4to2 uut (
    .I(I),
    .Y(Y)
);

initial begin
    $display("Time\tInput\tOutput");
    $monitor("%0t\t%b\t%b", $time, I, Y);

    I = 4'b0001; #10;
    I = 4'b0010; #10;
    I = 4'b0100; #10;
    I = 4'b1000; #10;

    // Invalid cases
    I = 4'b0000; #10;
    I = 4'b1010; #10;

    $finish;
end

endmodule
