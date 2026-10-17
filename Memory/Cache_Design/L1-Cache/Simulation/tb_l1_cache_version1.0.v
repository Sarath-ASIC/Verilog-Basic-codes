`timescale 1ns/1ps

module tb_beginner_l1_cache;

    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst = 1'b1;
    reg req_valid = 1'b0;
    reg [3:0] req_addr = 4'd0;

    wire req_ready;
    wire resp_valid;
    wire [7:0] resp_data;
    wire hit;
    wire miss;

    integer hit_count = 0;
    integer miss_count = 0;

    beginner_l1_cache dut (
        .clk(clk),
        .rst(rst),
        .req_valid(req_valid),
        .req_addr(req_addr),
        .req_ready(req_ready),
        .resp_valid(resp_valid),
        .resp_data(resp_data),
        .hit(hit),
        .miss(miss)
    );

    always @(posedge clk) begin
        if (!rst) begin
            if (hit) begin
                hit_count = hit_count + 1;
                $display("[%0t] HIT event", $time);
            end
            if (miss) begin
                miss_count = miss_count + 1;
                $display("[%0t] MISS event", $time);
            end
            if (resp_valid)
                $display("[%0t] RESPONSE data=0x%02h", $time, resp_data);
        end
    end

    task automatic read_address(input [3:0] addr, input [7:0] expected);
        begin
            // Wait until the cache can accept a new request.
            @(negedge clk);
            while (req_ready !== 1'b1)
                @(negedge clk);

            req_addr  = addr;
            req_valid = 1'b1;
            @(negedge clk);
            req_valid = 1'b0;

            // Wait for response, with a safety timeout.
            fork : wait_for_response
                begin
                    wait (resp_valid === 1'b1);
                end
                begin
                    repeat (12) @(negedge clk);
                    $display("FAIL: timeout waiting for address %h", addr);
                    $finish;
                end
            join_any
            disable wait_for_response;

            if (resp_data !== expected) begin
                $display("FAIL: address %h expected %h, got %h",
                         addr, expected, resp_data);
                $finish;
            end else begin
                $display("PASS: address %h returned %h", addr, resp_data);
            end

            @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("beginner_l1_cache.vcd");
        $dumpvars(0, tb_beginner_l1_cache);

        repeat (2) @(negedge clk);
        rst = 1'b0;

        // Address 2: first access is a miss, then the same address hits.
        read_address(4'h2, 8'hF0);
        read_address(4'h2, 8'hF0);

        // Address 6 has the same index as address 2 but a different tag.
        // It replaces line 2 and must miss.
        read_address(4'h6, 8'h77);

        // Address 2 now misses again because address 6 replaced its line.
        read_address(4'h2, 8'hF0);

        if (hit_count < 1 || miss_count < 3) begin
            $display("FAIL: event counts unexpected (hits=%0d, misses=%0d)",
                     hit_count, miss_count);
            $finish;
        end

        $display("ALL TESTS COMPLETED: hits=%0d, misses=%0d",
                 hit_count, miss_count);
        $finish;
    end

endmodule
