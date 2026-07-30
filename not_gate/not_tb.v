`timescale 1ns/1ps

module not_tb;
  reg a ;
  wire y;

  not_gate dut1 ( .a(a), 
                 .y(y));
  initial begin

    $dumpfile("not_gate.vcd");
    $dumpvars(0, not_tb);

     a = 1; #5
     a= 0;  #5
    $finish;

  end 
endmodule
