`timescale 1ns/1ps

module mux3to1_tb;

reg i0, i1, i2;
reg [1:0] sel;
wire y;

integer i;

// DUT
mux3to1 dut (
    .i0(i0),
    .i1(i1),
    .i2(i2),
    .sel(sel),
    .y(y)
);

initial begin

    $display("Time\tSel\tI2 I1 I0\tY");
    $monitor("%0t\t%b\t %b  %b  %b\t%b",
             $time, sel, i2, i1, i0, y);

    // Generate every possible input combination
    for(i = 0; i < 8; i = i + 1) begin
        {i2, i1, i0} = i;

        // Test every select value
        for(sel = 0; sel < 4; sel = sel + 1)
            #10;
    end

    $finish;

end

endmodule
