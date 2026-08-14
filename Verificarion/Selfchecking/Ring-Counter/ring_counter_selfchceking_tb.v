`timescale 1ns/1ps

module ring_counter_sim;

    reg        clk;
    reg        rst;
    wire [3:0] ring_out;

    reg  [3:0] expected;
    integer    pass_count;
    integer    fail_count;

    // DUT INSTANTIATION
    ring_counter dut1 (
        .clk      (clk),
        .rst      (rst),
        .ring_out (ring_out)
    );

    //============================================================
    // CLOCK GENERATION
    // 10 ns period -> 100 MHz
    //============================================================
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    //============================================================
    // RESET TASK
    //============================================================
    task apply_reset;
    begin
        rst = 1'b1;

        repeat (2)
            @(posedge clk);

        #1;

        // Reset must force the DUT to 0001
        if (ring_out !== 4'b0001) begin
            $display("FAIL: Reset check | Time=%0t | Expected=0001 | Got=%b",
                     $time, ring_out);
            fail_count = fail_count + 1;
        end
        else begin
            $display("PASS: Reset check | Time=%0t | ring_out=%b",
                     $time, ring_out);
            pass_count = pass_count + 1;
        end

        rst = 1'b0;

        // Expected state after reset release
        expected = 4'b0001;
    end
    endtask

    //============================================================
    // SELF-CHECKING TEST
    //============================================================
    initial begin

        $dumpfile("ring_counter.vcd");
        $dumpvars(0, ring_counter_sim);

        pass_count = 0;
        fail_count = 0;
        expected   = 4'b0001;

        // Apply reset
        apply_reset();

        //========================================================
        // Verify 20 active clock cycles
        //
        // Ring counter period = 4 cycles
        // 20 cycles = 5 complete rotations
        //========================================================
        repeat (20) begin

            @(posedge clk);

            // Allow DUT nonblocking assignment to update
            #1;

            // Calculate expected next state
            expected = {expected[2:0], expected[3]};

            // Compare DUT against expected value
            if (ring_out !== expected) begin

                $display("FAIL: Time=%0t | Expected=%b | Got=%b",
                         $time, expected, ring_out);

                fail_count = fail_count + 1;
            end
            else begin

                $display("PASS: Time=%0t | Expected=%b | Got=%b",
                         $time, expected, ring_out);

                pass_count = pass_count + 1;
            end

        end

        //========================================================
        // FINAL RESULT
        //========================================================
        $display("");
        $display("======================================");
        $display("       RING COUNTER TEST RESULT       ");
        $display("======================================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0) begin
            $display("TEST RESULT = PASS");
        end
        else begin
            $display("TEST RESULT = FAIL");
        end

        $display("======================================");

        $finish;
    end

endmodule
