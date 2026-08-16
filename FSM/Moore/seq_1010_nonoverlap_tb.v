`timescale 1ns/1ps

module tb_seq_detector_1010_moore;

    reg clk;
    reg rst;
    reg din;
    wire detected;

    integer errors;

    seq_detector_1010_moore dut (
        .clk      (clk),
        .rst      (rst),
        .din      (din),
        .detected (detected)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    // Apply one input bit per clock
    task send_bit;
        input bit_value;
        begin
            din = bit_value;
            @(posedge clk);
            #1;
        end
    endtask

    // Check detector output
    task check_output;
        input expected;
        begin
            if (detected !== expected) begin
                $display("ERROR: time=%0t din=%b detected=%b expected=%b",
                         $time, din, detected, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk    = 0;
        rst    = 1;
        din    = 0;
        errors = 0;

        // Reset
        @(posedge clk);
        #1;
        rst = 0;

        
        // Test 1: 1010 -> detection expected
       
        send_bit(1); check_output(0);
        send_bit(0); check_output(0);
        send_bit(1); check_output(0);
        send_bit(0); check_output(1);

        
        // Test 2: 101010
        // Non-overlapping detector should detect only
        // the first 1010.
        
        send_bit(1); check_output(0);
        send_bit(0); check_output(0);
        send_bit(1); check_output(0);
        send_bit(0); check_output(1);
        send_bit(1); check_output(0);
        send_bit(0); check_output(0);

        
        // Test 3: No complete sequence
       
        send_bit(1); check_output(0);
        send_bit(0); check_output(0);
        send_bit(1); check_output(0);

        
        // Result
        
        if (errors == 0)
            $display("TEST PASSED");
        else
            $display("TEST FAILED: %0d errors", errors);

        $finish;
    end

endmodule
