`timescale 1ns/1ps

module mux_sim;
reg i0,i1,i2,i3,i4,i5,i6,i7;
reg s0,s1,s2;
wire y;

mux_8_to_1 dut1 ( .i0(i0), .i1(i1), .i2(i2), 
                  .i3(i3), .i4(i4), .i5(i5), 
                  .i6(i6), .i7(i7), 
                  .s0(s0), .s1(s1), .s2(s2),
                  .y(y)
                  );
                  
initial begin
$dumpfile("mux81.vcd");
$dumpvars(0, mux_sim);

$monitor("Time = %0t s2 = %b s1= %b s0=%b y = %b", $time, s2, s1,s0,y);
//fixing the inputs of the multipplexer
i0 =1; i1=1; i2= 0; i3=1; i4=0; i5=1; i6=1; i7=0;

//selectline
s0 =0; s1=0; s2=0; #2;
s0 =0; s1=0; s2=1; #2;
s0 =0; s1=1; s2=0; #2;
s0 =0; s1=1; s2=1; #2;
s0 =1; s1=0; s2=0; #2;
s0 =1; s1=0; s2=1; #2;
s0 =1; s1=1; s2=0; #2;
s0 =1; s1=1; s2=1; #2;
end
endmodule

 
