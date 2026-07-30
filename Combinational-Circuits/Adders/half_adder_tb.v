`timescale 1ns/1ps

module Half_Adder_Sim;
reg a ,b;
wire sum, carry;

Half_Adder dut1 ( .a(a), .b(b) , .sum(sum) , .carry(carry) );

initial begin

a=0;
b= 0;

$monitor("Time= %0t a=%b b=%b sum =%b carry=%t ", $time, a,b,sum,carry);
$dumpfile("adder.vcd");
$dumpvars(0, Half_Adder_Sim);

a=0; 
b=0;
#10;

a=0;
b=0;
#10;

a=1;
b=0;
#10;

a=1;
b=1;
#10;

#20; $finish;
end
endmodule
