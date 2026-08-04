`timescale  1ns/1ps

module dflop_sim;
reg clk, d, rst;
wire q, q_bar;

d_flop dut1( .d(d), 
             .clk(clk), 
             .rst(rst), 
             .q(q), 
             .q_bar(q_bar) );
             
             //clk generation block
             initial begin
             clk =1'b0;
             forever #5 clk = ~clk;
             end
             
             //task block
             task apply_d;
             input d_in;
             
             begin
             @(negedge clk); 
             d = d_in;
             end
             
             endtask
             
             //DUT signling
             integer i;
             
             initial begin 
             
             $dumpfile("dflop.vcd");
             $dumpvars(0, dflop_sim);
             
             for( i= 0; i<8; i = i+1)
             apply_d(i);
             
             for(i=1; i>=0; i= i-1)
             apply_d(i);
             
             repeat(2) @(posedge clk);
             $finish;
             
             end
             endmodule
             
