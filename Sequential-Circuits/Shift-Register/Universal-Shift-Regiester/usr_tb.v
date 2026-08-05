`timescale 1ns/1ps
module usr_sim;
reg clk;
reg [3:0] d;
reg[1:0] mode_sel;
reg shift_left, shift_right;

wire [3:0] q;

usr dut1 ( .clk(clk),
           .d(d),
           .mode_sel(mode_sel),
           .shift_left(shift_left),
           .shift_right(shift_right),
           .q(q)
           );
           
           // clock generation block 
           initial begin
           clk =0;
           forever #5
           clk = ~clk;
           end
           //reusable task creation
           task usr_in;
           input [3:0] d_in;
           input [1:0] mode;
           input sl;
           input sr;
           
           begin @(negedge clk)
           mode_sel= mode;
           d = d_in;
           shift_left=sl;
           shift_right=sr;
           end
           endtask
           
           //DUT Sequencing
           initial begin 
           $dumpfile("usr.vcd");
           $dumpvars(0, usr_sim);
                     //input
           usr_in(4'b1010,2'b11,0,0);   // Parallel Load

           repeat(2) @(posedge clk);

           usr_in(4'b0000,2'b10,1,0);   // Shift Left

           repeat(2) @(posedge clk);

           usr_in(4'b0000,2'b01,0,1);   // Shift Right

            repeat(2) @(posedge clk);

            usr_in(4'b0000,2'b00,0,0);   // Hold
            $finish;
            end 
            endmodule
            
          
          
