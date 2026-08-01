`timescale 1ns/1ps

module decoder3_8_sim;

reg [2:0] in;
wire [7:0] y;

decoder_3_8 dut1 ( .in(in), .y(y) );

initial begin
$dumpfile("decoder38.vcd");
$dumpvars(0, decoder3_8_sim);
$monitor("Time =0%t in=%b y=%b", $time, in, y);

in = 3'b000; #5;
in = 3'b001; #5;
in = 3'b010; #5;
in = 3'b011; #5;
in = 3'b100; #5;
in = 3'b101; #5;
in = 3'b110; #5;
in = 3'b111; #5;

end 
endmodule

