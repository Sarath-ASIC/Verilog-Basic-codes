`timescale 1ns/1ps

module nand_sim;
reg a, b;
wire y;


nand_gate dut1 ( .a(a), .b(b),.y(y));

initial begin
a= 0;
b =0;
end

initial begin
$dumpfile("nandgate.vcd");
$dumpvars(0, nand_sim);
$monitor("time:%b a:%b b:%b y:%b", $time, a,b,y);

a=0; b=0; #5;
a=0; b=1; #5;
a=1; b=0; #5;
a=1; b=1; #5;
#20 $finish;

end
endmodule
