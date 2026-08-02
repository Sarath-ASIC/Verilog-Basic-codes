`timescale 1ns/1ps

module srlatch_sim;

reg s, r;
wire q, qbar;

sr_latch dut1 ( .s(s), .r(r), .q(q), .qbar(qbar) ) ;

initial begin
$dumpfile("srlatch.vcd");
$dumpvars(0, srlatch_sim);

$monitor("Time: %0t S: %b R:%b Q:%b Qbar:%b" , $time, s,r,q,qbar);

s=0; r=0; #5;
s=0; r=1; #5;
s=1; r=0; #5;
s=1; r=1; #5;
s=0; r=0; #5;
s=1; r=0; #5;
s=0; r=1; #5;
s=0; r=0; #5;
#5 $finish;
end
endmodule
