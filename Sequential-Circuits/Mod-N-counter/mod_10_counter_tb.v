`timescale 1ns/1ps

module mod10_counter_tb;

reg clk;
reg rst;

wire [3:0] q;

mod10_counter dut(
    .clk(clk),
    .rst(rst),
    .q(q)
);



initial begin

    clk = 0;

    forever #5 clk = ~clk;

end



task apply_reset;

begin

    rst = 1;

    repeat(2)
        @(posedge clk);

    rst = 0;

end

endtask



initial begin

    $dumpfile("mod10.vcd");
    $dumpvars(0,mod10_counter_tb);

    $monitor("Time=%0t Count=%d Binary=%b",
             $time,q,q);

    apply_reset();

    repeat(15)
        @(posedge clk);

    $finish;

end

endmodule
