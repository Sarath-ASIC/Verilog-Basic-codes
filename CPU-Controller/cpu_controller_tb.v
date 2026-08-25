`timescale 1ns/1ps

module simple_peripheral_tb;
    reg clk;
    reg reset;
    reg [31:0] address;
    reg [31:0] write_data;
    reg        write_enable;
    wire led_out;


    // Instantiate the peripheral
    simple_peripheral dut (

        .clk(clk),
        .reset(reset),

        .address(address),
        .write_data(write_data),
        .write_enable(write_enable),

        .led_out(led_out)

    );


    // Clock generation
    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end


    // Simulated CPU
    initial begin

        // Initial values
        reset        = 1;
        address      = 32'h0000_0000;
        write_data   = 32'h0000_0000;
        write_enable = 0;


        // Keep reset active
        #20;

        reset = 0;


        // Wait for a clock edge
        #10;


        // ========================================
        // CPU WRITE:
        //
        // *(CONTROL_ADDRESS) = 1
        //
        // ========================================

        address      = 32'h0000_0000;
        write_data   = 32'h0000_0001;
        write_enable = 1;

        #10;


        // End write transaction
        write_enable = 0;

        #20;


        // ========================================
        // CPU WRITE:
        //
        // *(CONTROL_ADDRESS) = 0
        //
        // ========================================

        address      = 32'h0000_0000;
        write_data   = 32'h0000_0000;
        write_enable = 1;

        #10;


        // End write transaction
        write_enable = 0;

        #20;

        $finish;

    end

endmodule
