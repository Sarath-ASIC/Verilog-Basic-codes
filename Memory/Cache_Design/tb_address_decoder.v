
`timescale 1ns/1ps

module address_decoder_sim;

    localparam NUM_TESTS = 1000;

    reg  [6:0] address;
    reg        valid;
    reg  [2:0] stored_tag;

    wire [2:0] requested_tag;
    wire [1:0] index;
    wire [1:0] offset;
    wire       hit;
    wire       miss;

    integer i;
    integer errors;

    reg [2:0] expected_tag;
    reg [1:0] expected_index;
    reg [1:0] expected_offset;
    reg       expected_hit;
    reg       expected_miss;

    // DUT instantiation
    address_decoder uut0 (
        .address       (address),
        .valid         (valid),
        .stored_tag    (stored_tag),
        .requested_tag (requested_tag),
        .index         (index),
        .offset        (offset),
        .hit            (hit),
        .miss           (miss)
    );

    initial begin
        errors = 0;

        for (i = 0; i < NUM_TESTS; i = i + 1) begin

            // Generate random inputs
            address    = $random;
            valid      = $random;
            stored_tag = $random;

            // Allow combinational logic to settle
            #1;

            // Calculate expected results independently
            expected_tag    = address[6:4];
            expected_index  = address[3:2];
            expected_offset = address[1:0];

            expected_hit =
                valid && (expected_tag == stored_tag);

            expected_miss = ~expected_hit;

            // Compare actual DUT outputs against expected values
            if ((requested_tag !== expected_tag) ||
                (index         !== expected_index) ||
                (offset        !== expected_offset) ||
                (hit            !== expected_hit) ||
                (miss           !== expected_miss)) begin

                $display("FAIL: Test %0d", i);
                $display("Address       = %b", address);
                $display("Valid         = %b", valid);
                $display("Stored tag    = %b", stored_tag);
                $display("Requested tag = %b (expected %b)",
                         requested_tag, expected_tag);
                $display("Index         = %b (expected %b)",
                         index, expected_index);
                $display("Offset        = %b (expected %b)",
                         offset, expected_offset);
                $display("Hit           = %b (expected %b)",
                         hit, expected_hit);
                $display("Miss          = %b (expected %b)",
                         miss, expected_miss);

                errors = errors + 1;
            end
        end

        $display("--------------------------------");
        $display("Address Decoder Random Test");
        $display("Total tests : %0d", NUM_TESTS);
        $display("Errors      : %0d", errors);

        if (errors == 0)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        $finish;
    end

    initial begin
        $dumpfile("address_decoder.vcd");
        $dumpvars(0, address_decoder_sim);
    end

endmodule
