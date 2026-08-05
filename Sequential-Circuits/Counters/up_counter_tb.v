`timescale 1ns/1ps

module up_counter_sim;
reg clk, rst;
wire [3:0] q;

up_counter dut1 ( .clk(clk),
                  .rst(rst),
                  .q(q)
                  );
                  
                  //clock
                  initial begin
                  clk = 0;
                  forever #5 clk = ~clk;
                  end
                  
                  // reusbale task
                  task apply_rst;
                  begin
                  rst =1;
                  repeat (2) 
                  @(negedge clk);
                  
                  rst =0;
                  end 
                  endtask
                  
                  //DUT Signalling
                  initial begin
                  $dumpfile("upcounter.vcd");
                  $dumpvars(0, up_counter_sim);
                  
                  $monitor("Time = %0t rst =%b  clk =%b q =%b" , $time , rst, clk, q);
                  
                  apply_rst();
                  repeat(20)
                  @(posedge clk);
                  
                  $finish;
                  end
                  endmodule
                  
                 
