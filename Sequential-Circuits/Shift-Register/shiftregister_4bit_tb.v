`timescale 1ns/1ps

module register_4bit_sim;
reg [3:0] d;
reg clk;
wire [3:0]q;

register_4bit dut1 ( .d(d),
                     .clk(clk),
                     .q(q)
                     );
                     
                     initial begin
                     clk = 0;
                     forever #5 clk = ~ clk;
                     end 
                     
                     task reg_in;
                     input [3:0] d_in;
                     begin @(negedge clk);
                     d= d_in;
                     end
                     endtask
                     
                     integer i;
                     
                     initial begin 
                     
                     $dumpfile("register_4bit");
                     $dumpvars(0, register_4bit_sim);
                     
                     $monitor("Time = %0t  d =%b  clk =%b q= %b " , $time, d, clk, q);
                     
                     for(i =0; i < 16; i = i+1)
                     reg_in(i);
                     
                     repeat(2) @(posedge clk);
                     
                     $finish;
                     end
                     endmodule
                     
