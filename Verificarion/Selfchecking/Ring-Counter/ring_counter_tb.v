`timescale 1ns/1ps

module ring_counter_sim;

reg clk;
reg rst;
wire [3:0] ring_out;

//DUT INSTANTIATION
ring_counter dut1 ( 
                   .clk          ( clk     ),
                   .rst          ( rst     ),
                   .ring_out     ( ring_out)
                   );
                   
                   //system clock generation
                   initial begin
                   clk= 1'b0;
                   forever #5 clk = ~clk;
                   end
                   
                   //re-usable task
                   task apply_reset;
                   begin
                   rst = 1'b1;
                   repeat(2)
                   
                   @(posedge clk);
                   rst= 1'b0;
                   end
                   endtask
                   
                   //Signillaing
                   
                   initial begin
                   
                   $dumpfile("ring_counter.vcd");
                   $dumpvars(0, ring_counter_sim);
                   
                   $monitor("TIme = %0t clk =%b rst = %b  ring_out = %b" ,
                    $time, clk, rst, ring_out);
                   
                   apply_reset();
                   
                   repeat(20)
                   begin
                   @(posedge clk);
                   end
                   
                   #200; $finish;
                   end
                   
                   
                   endmodule                 
                   
                   
                   
