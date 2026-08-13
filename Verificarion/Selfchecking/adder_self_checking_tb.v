`timescale 1ns/1ps

module full_adder_tb;

    // ------------------------------------------------
    // DUT signals
    // ------------------------------------------------

    reg  [3:0] a;
    reg  [3:0] b;
    reg        cin;

    wire [3:0] sum;
    wire       cout;

    // Expected result
    reg  [4:0] expected;

    integer error_count;


    
    // DUT
   

    full_adder dut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
    );


   
    // Self-checking test
  

    integer i;
    integer j;
    integer k;

    initial begin

        $dumpfile("full_adder.vcd");
        $dumpvars(0, full_adder_tb);

        error_count = 0;

        // Exhaustively test all combinations
        // a= 4bits  => 16 possibility
        //b =4 bits => 16 possibility
        //c=2 bits => 2 possibilily
        // => 16 * 16 * 2 =512 cases neeed to cehck
        for (i = 0; i < 16; i = i + 1) begin

            for (j = 0; j < 16; j = j + 1) begin

                for (k = 0; k < 2; k = k + 1) begin

                    a   = i;
                    b   = j;
                    cin = k;

                    #1;

                    // Reference model
                    expected = a + b + cin;

                    // Checker
                    if ({cout, sum} !== expected) begin

                        $display(
                            "FAIL: A=%0d B=%0d Cin=%0d Expected=%0d Actual=%0d",
                            a, b, cin, expected, {cout, sum}
                        );

                        error_count = error_count + 1;

                    end
                    else begin

                        $display(
                            "PASS: A=%0d B=%0d Cin=%0d Result=%0d",
                            a, b, cin, {cout, sum}
                        );

                    end

                end

            end

        end


        
        // Final result
        

        if (error_count == 0) begin

            $display("====================================");
            $display("       TEST PASSED");
            $display("       512/512 CASES PASSED");
            $display("====================================");

        end
        else begin

            $display("====================================");
            $display("       TEST FAILED");
            $display("       ERRORS = %0d", error_count);
            $display("====================================");

        end

        $finish;

    end

endmodule
