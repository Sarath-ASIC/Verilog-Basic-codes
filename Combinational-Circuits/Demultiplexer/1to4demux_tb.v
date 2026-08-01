`timescale 1ns/1ps

module demux_1_to_4_tb;

reg in;
reg [1:0] s;

wire [3:0] y;

demux_1_to_4 dut(

    .in(in),
    .s(s),
    .y(y)

);

initial begin

    $dumpfile("demux14.vcd");
    $dumpvars(0, demux_1_to_4_tb);

    $monitor("Time=%0t IN=%b S=%b Y=%b",
              $time,in,s,y);

    //--------------------------
    // Input = 1
    //--------------------------

    in = 1;

    s = 2'b00; #5;
    s = 2'b01; #5;
    s = 2'b10; #5;
    s = 2'b11; #5;

    //--------------------------
    // Input = 0
    //--------------------------

    in = 0;

    s = 2'b00; #5;
    s = 2'b01; #5;
    s = 2'b10; #5;
    s = 2'b11; #5;

    $finish;

end

endmodule
