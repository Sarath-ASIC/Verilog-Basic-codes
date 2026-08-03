`timescale 1ns/1ps

module srflop_sim;
reg s,r,clk, rst;
wire q, qbar;
//portmapping
srflop dut1 ( .s(s),
              .r(r), 
              .q(q),
              .clk(clk),
              .rst(rst),
              .qbar(qbar)
              );
              initial begin
              clk =0;
              forever #5 clk = ~clk;
              end
              
              //signalling to DUT:
              initial begin
              $dumpfile("srflop.vcd");
              $dumpvars(0,srflop_sim);
              
              rst = 1; // reset is 1 == high == expected output is "0"
              s=0; r=0; #5;
              
              rst =0; //reset is deasserted; Normal Working.
              s=0; r=0; #5;
              s=0; r=1; #5;
              s=1; r=0; #5;
              s=1; r=1; #5;
              #10; $finish;
              
              
              end
              endmodule
              
