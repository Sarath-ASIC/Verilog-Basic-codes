`timescale 1ns/1ps

module ripple_counter_sim;

reg clk, rst;
wire [3:0] q;

ripple_counter dut1 ( .clk(clk), 
                      .rst(rst), 
                      .q(q)
                      );
                      
                      // clock 
                      initial begin
                      clk =0;
                      forever #5 clk = ~ clk;
                      end
                      
                      //reusable task
                      task ripple_in;
                      begin
                      rst = 1;
                      repeat(2) @(negedge clk);
                      rst =0;
                      end
                      endtask
                      
                      //DUT Signilling
                      initial begin
                      $dumpfile("rc.vcd");
                      $dumpvars(0, ripple_counter_sim);
                      
                      $monitor("Time =%0t clk=%b rst= %b q=%b" , 
                                $time , clk, rst, q);
                      
                      ripple_in();
                      repeat(20) 
                      @(posedge clk);
                      $finish;
                      end
                      endmodule
                       
                      
                      
                       
