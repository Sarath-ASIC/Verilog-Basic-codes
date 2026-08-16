`timescale 1ns/1ps

module tb_seq_detector_1010_mealy_nonoverlap;

    reg clk;
    reg rst;
    reg din;

    wire detected;

    integer errors;

    seq_detector_1010_mealy_nonoverlap dut (
        .clk      (clk),
        .rst      (rst),
        .din      (din),
        .detected (detected)
    );

    // 10 ns clock
    always #5 clk = ~clk;


   
    // Apply one input bit and check expected output
    
    task send_bit;
        input bit_value;
        input expected;

        begin
            // Apply input before active clock edge
            @(negedge clk);
            din = bit_value;

            // Mealy output is combinational
            #1;

            if (detected !== expected) begin
                $display("ERROR: time=%0t din=%b detected=%b expected=%b",
                         $time, din, detected, expected);
                errors = errors + 1;
            end

            // Allow FSM to capture the input
            @(posedge clk);
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


       
        // TEST 1
        // Input = 1010
        // Expected detection = 1 on final 0
        

        send_bit(1, 0);
        send_bit(0, 0);
        send_bit(1, 0);
        send_bit(0, 1);


        // ------------------------------------------------
        // TEST 2
        // Input = 101010
        //
        // Non-overlapping:
        //
        // 1010 -> detected
        //      10 -> incomplete
        //
        // Only ONE detection expected.
        // ------------------------------------------------

        send_bit(1, 0);
        send_bit(0, 0);
        send_bit(1, 0);
        send_bit(0, 1);
        send_bit(1, 0);
        send_bit(0, 0);


        // ------------------------------------------------
        // TEST 3
        // Input = 1111
        // No 1010 should be detected.
        // ------------------------------------------------

        send_bit(1, 0);
        send_bit(1, 0);
        send_bit(1, 0);
        send_bit(1, 0);


        // ------------------------------------------------
        // TEST 4
        // Input = 11010
        // The final 1010 does NOT exist.
        // ------------------------------------------------

        send_bit(1, 0);
        send_bit(1, 0);
        send_bit(0, 0);
        send_bit(1, 0);
        send_bit(0, 1);


        
        // Final result
       

        if (errors == 0)
            $display("TEST PASSED");
        else
            $display("TEST FAILED: %0d errors", errors);

        $finish;

    end

endmodule
