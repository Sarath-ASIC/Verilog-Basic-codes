`timescale 1ns/1ps

module subtractor_sim;
reg a,b;
wire diff, borrow;

subtractor dut1 ( .a(a), .b(b), .diff(diff), .borrow(borrow));

initial begin
a=0;
b=0;

$dumpfile("sub.vcd");
$dumpvars(0, subtractor_sim);

a=0; b=0; #5;
a=0; b=1; #5;
a=1; b=0; #5;
a=1; b=1; #5;
#10 $finish;
end
endmodule
