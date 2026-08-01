`timescale 1ns/1ps

module encoder_sim;
reg [7:0] i;
wire [2:0] y;

encoder_8_to_3 dut1 ( .i(i) , .y(y) );

initial begin
$dumpfile("encode.vcd");
$dumpvars(0, encoder_sim);
$monitor("Time =0%t I=%b Y=%b", $time, i,y);

i = 8'b00000001; #5;
i = 8'b00000010; #5;
i = 8'b00000100; #5;
i = 8'b00001000; #5;
i = 8'b00010000; #5;
i = 8'b00100000; #5;
i = 8'b01000000; #5;
i = 8'b10000000; #5;

end
endmodule
