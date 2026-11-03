
`timescale 1ns/1ps

module tb_ddr_transmitter;

    reg clk;
    reg rst;
    reg [15:0] data_in;

    wire [7:0] data_out;

    integer errors;

    // DUT instantiation
    ddr_transmitter DUT (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );

    // 100 MHz clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        rst = 1;
        data_in = 16'h0000;
        errors = 0;

        // Hold reset
        #12;
        rst = 0;

        // Test pattern 1
        data_in = 16'hA53C;
        #10;

        // Test pattern 2
        data_in = 16'hB46D;
        #10;

        // Test pattern 3
        data_in = 16'hC781;
        #10;

        // Test pattern 4
        data_in = 16'hD29E;
        #10;

        // Test pattern 5
        data_in = 16'h5AF0;
        #10;

        $display("--------------------------------");
        $display("DDR TRANSMITTER TEST COMPLETED");
        $display("Total Errors = %0d", errors);
        $display("--------------------------------");

        if (errors == 0)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $finish;
    end

    // Check positive edge
    always @(posedge clk) begin
        if (!rst) begin
            #1;
            if (data_out !== data_in[15:8]) begin
                $display(
                    "ERROR at POS edge: Expected=%h Actual=%h",
                    data_in[15:8], data_out
                );
                errors = errors + 1;
            end
            else begin
                $display(
                    "POS EDGE: Input=%h Output=%h PASS",
                    data_in, data_out
                );
            end
        end
    end

    // Check negative edge
    always @(negedge clk) begin
        if (!rst) begin
            #1;
            if (data_out !== data_in[7:0]) begin
                $display(
                    "ERROR at NEG edge: Expected=%h Actual=%h",
                    data_in[7:0], data_out
                );
                errors = errors + 1;
            end
            else begin
                $display(
                    "NEG EDGE: Input=%h Output=%h PASS",
                    data_in, data_out
                );
            end
        end
    end

endmodule
