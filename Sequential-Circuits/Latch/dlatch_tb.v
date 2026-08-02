`timescale 1ns/1ps

module d_latch_tb;

reg D;
reg EN;

wire Q;
wire Qbar;

d_latch dut(

.D(D),
.EN(EN),

.Q(Q),
.Qbar(Qbar)

);

initial begin

$dumpfile("d_latch.vcd");
$dumpvars(0,d_latch_tb);

$monitor("Time=%0t EN=%b D=%b Q=%b",
          $time,EN,D,Q);

// Enabled

EN=1;

D=0; #5;

D=1; #5;

D=0; #5;

D=1; #5;

// Disable

EN=0;

D=0; #5;

D=1; #5;

D=0; #5;

$finish;

end

endmodule
