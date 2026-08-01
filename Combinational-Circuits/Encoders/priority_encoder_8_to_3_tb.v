`timescale 1ns/1ps

module  priority_encoder_8to_3_sim;
reg [7:0] in;
wire [2:0] out;

priority_encoder_8to_3 dut1 (.in(in), .out(out) );
 
initial begin
$dumpfile("prio_enc.vcd");
$dumpvars(0,priority_encoder_8to_3_sim);
$monitor("Time = %0t in:%b out:%b", $time, in, out);

//single HIGH signals
in= 8'b00000000; #5;
in= 8'b00000010; #5;
in= 8'b00000100; #5;
in= 8'b00001000; #5;
in= 8'b00010000; #5;
in= 8'b00100000; #5;
in= 8'b01000000; #5;
in= 8'b10000000; #5;

// 2 or more HIGH Signal

in= 8'b00000010; #5;
in= 8'b00011000; #5;
in= 8'b11000000; #5;
in= 8'b10000001; #5;
#20; $finish;
end 
endmodule
