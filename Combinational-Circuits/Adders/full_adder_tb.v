`timescale 1ns/1ps

module full_adder_sim;

reg a , b, c_in;
wire sum, c_out;
integer i;

full_adder dut1( .a(a),
.b(b),
.c_in(c_in),
.sum(sum),
.c_out(c_out)
);


initial begin
$dumpfile("fulladder.vcd");
$dumpvars(0, full_adder_sim);


for(i=0; i<8; i= i+1)
begin
{a,b,c_in} =i;
#10;
$display("%b %b %b %b %b", a, b,c_in, sum, c_out);
end
end
endmodule
