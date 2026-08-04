`timescale 1ns/1ps

module dflop_asnync_rst_sim;
reg d, clk, rst;
wire q , qbar;

dflop_async_rst dut1 ( .d(d), 

                       .clk(clk),
                       
                       .rst(rst),
                       
                       .q(q),
                       
                       .qbar(qbar)
                       );
                       
                       
                       //clock creration 
                       initial begin 
                       clk = 0;
                       forever #5 clk = ~clk;
                       end 
                       
                       //task 
                       task d_in;
                       input d_input;
                       input rst_in;
                       begin 
                       @(negedge clk);
                       rst = rst_in;
                       d =d_input;
                       end
                       endtask
                       
                       //DUT Sequencing
                       initial begin
                       $dumpfile("async_dfop.vcd");
                       $dumpvars(0, dflop_asnync_rst_sim);
                       
                       $monitor("Time =%b q=%b clk=%b rst=%b", 
                       $time, q,clk, rst);
                       
                       d_in(0,0);
                       d_in(0,1);
                       #2 rst =1;
                       #6 rst =0;
                       d_in(1,0);
                       d_in(1,1);
                       $finish;
                       end
                       
                       endmodule
                       
                       
                       
                                             
                        
                       
                    
                       
