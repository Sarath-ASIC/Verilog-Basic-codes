`timescale 1ns/1ps

module t_flipflop_tb;

reg clk;
reg t;

wire q;
wire qbar;

//-------------------------------------
// DUT
//-------------------------------------

t_flipflop dut(

    .clk(clk),
    .t(t),
    .q(q),
    .qbar(qbar)

);

//-------------------------------------
// Clock
//-------------------------------------

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//-------------------------------------
// Task
//-------------------------------------

task apply_t;

    input t_in;

begin

    @(negedge clk);

    t = t_in;

end

endtask

//-------------------------------------
// Test
//-------------------------------------

integer i;

initial begin

    $dumpfile("tff.vcd");
    $dumpvars(0,t_flipflop_tb);

    $monitor("Time=%0t CLK=%b T=%b Q=%b",
             $time,clk,t,q);

    // Hold
    apply_t(0);

    // Toggle for 6 clock cycles
    for(i=0;i<6;i=i+1)
        apply_t(1);

    // Hold again
    apply_t(0);

    repeat(2) @(posedge clk);

    $finish;

end

endmodule
