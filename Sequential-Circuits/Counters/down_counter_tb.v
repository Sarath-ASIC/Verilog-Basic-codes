`timescale 1ns/1ps

module sync_down_counter_tb;

reg clk;
reg rst;

wire [3:0] q;

sync_down_counter dut(
    .clk(clk),
    .rst(rst),
    .q(q)
);


// Clock


initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


// Reset Task


task apply_reset;
begin
    rst = 1;
    repeat(2) @(posedge clk);
    rst = 0;
end
endtask


// Test


initial begin

    $dumpfile("down_counter.vcd");
    $dumpvars(0, sync_down_counter_tb);

    $monitor("Time=%0t Reset=%b Count=%b",
             $time, rst, q);

    apply_reset();

    repeat(20)
        @(posedge clk);

    $finish;

end

endmodule
