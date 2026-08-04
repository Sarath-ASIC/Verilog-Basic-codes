`timescale 1ns/1ps

module siso_sim;

reg s_in, clk;
wire s_out;

siso_sr dut1 ( 
               .s_in(s_in),
               .clk(clk),
               .s_out(s_out)
               
               );
               // clock creation
               initial begin 
               clk =0; 
               forever #5 clk = ~clk;
               end 
               // resuable task
               task shift_in;
               input siso_in;
               begin 
               @(negedge clk)
               s_in = siso_in;
               end
               endtask
               
               //DUT Signals
               initial begin
               $dumpfile("siso.vcd");
               $dumpvars(0,siso_sim);
               
               $monitor( "Time =%0t s_in=%b clk =%b s_out = %b", $time , s_in ,clk, s_out);
               
               shift_in(1);
               shift_in(0);
               shift_in(1);
               shift_in(1);
               
               repeat(4) 
               shift_in(1);
               
               repeat(2) @(posedge clk);
               
               $finish;
               end
               endmodule
               
