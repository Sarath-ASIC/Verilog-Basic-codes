`timescale 1ns/1ps
module decoder24_sim;

reg [1:0] i;
wire [3:0] y;

decoder2_4 dut1 ( .i(i), .y(y) );

initial begin

$dumpfile("decoder24.vcd");
$dumpvars(0, decoder24_sim);
$monitor("Time =%0t i= %b y=%b", $time, i, y);

i = 2'b00; #5;
i = 2'b01; #5;
i = 2'b10; #5;
i = 2'b11; #5;
#20; 
$finish;
end
endmodule
