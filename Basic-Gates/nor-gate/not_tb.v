`timescale 1ns/1ps

module tb_nor_gate;

reg a;
reg b;
wire y;

nor_gate dut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin
    $dumpfile("nor_gate.vcd");
    $dumpvars(0, tb_nor_gate);

    a = 0; b = 0; #5;
    a = 0; b = 1; #5;
    a = 1; b = 0; #5;
    a = 1; b = 1; #5;

    $finish;
end

endmodule
