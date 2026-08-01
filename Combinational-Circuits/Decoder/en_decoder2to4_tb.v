`timescale 1ns/1ps

module en_decoder_sim;

reg [1:0] in;
reg en;
wire [3:0] out;

decoder_enable_2_4 dut1( .in(in), 
                         .en(en), 
                         .out(out) 
                         );


initial begin
$dumpfile("en_decoder.vcd");
$dumpvars(0, en_decoder_sim);
$monitor("Time =%0t in:&b en:%b out: %b", $time, in,en,out);

en= 1;
in= 2'b00; #5;
in= 2'b01; #5;

en= 0;
in = 2'b10; #5;
in = 2'b11; #5;

en=1;
in = 2'b00; #5;
in = 2'b01; #5;
in = 2'b10; #5;
in = 2'b11; #5;
end
endmodule
