`timescale 1ps/1ns

module nor_gate (input a ,b, output y):
  assign y = ~( a | b);
endmodule
