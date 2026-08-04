`timescale 1ns/1ps 

module sipo_sim;
reg s_in, clk;
wire [3:0] s_out;

sipo_sr dut1 ( .s_in(s_in), 
               .clk(clk),
               .s_out(s_out)
               );
               
               //clock generation clock
               initial begin
               clk =0;
               forever #5 clk = ~clk;
               end
               
               //reusable task
               task sipo_in;
               input shift_in;
               
               begin 
               @(negedge clk);
               s_in = shift_in;
               end
               endtask
               
               
               //DUT Sequencing
               
               initial begin
               $dumpfile("sipo.vcd");
               $dumpvars(0, sipo_sim);
               
               $monitor("Time = %0t s_in = %b clk = %b s_out = %b" , $time, s_in, clk, s_out);
               
               sipo_in(1);
               sipo_in(0);
               sipo_in(1);
               sipo_in(0);
               
               repeat (4)
               sipo_in(0);
               
               repeat(2) 
               @(posedge clk)
               
               $finish;
               end
               endmodule
