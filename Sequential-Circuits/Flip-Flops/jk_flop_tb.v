`timescale 1ns/1ps

module jk_flop_sim;
reg j,k,clk;
wire q, qbar;

jk_flop dut1 ( .j(j), 
               .k(k), 
               .clk(clk), 
               .q(q), 
               .qbar(qbar)
               );
               
               //clock genereation 
               initial begin 
               clk = 0;
               forever #5 clk = ~clk;
               end
               
               //task creation 
               task jk_in;
               
               input j_input;
               input k_input;
               begin
               @(negedge clk); 
               j = j_input;
               k = k_input ;
               end
               endtask
               
               //integer
               integer i;
               
               //DUT signals sequence 
               
              initial begin
              $dumpfile("jkflop.vcd");
              $dumpvars(0, jk_flop_sim);
              
              $monitor(" Time =%t J=%t K=%t CLK=%b Q= %t",
                         $time, j, k, clk, q);
                         
                         jk_in(0,0);
                         jk_in(0,1);
                         jk_in(1,0);
                         jk_in(1,1);
                         
                         for(i=0; i<4; i=i+1 )
                         jk_in(1,1);
                         
                         repeat(2) @(posedge clk);
                         $finish;
                         end
                         endmodule
                       
                                 
    
