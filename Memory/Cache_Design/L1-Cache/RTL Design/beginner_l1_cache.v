`timescale 1ns/1ps

// Beginner-level direct-mapped L1 cache model.
// Address: 4 bits = {tag[3:2], index[1:0]}
// Cache: 4 lines, 1 byte per line; therefore there are no offset bits.
// Main memory is modeled as an initialized array with asynchronous read access.
// This is an educational functional model, not a timing-accurate SRAM model.

module beginner_l1_cache (
    input  wire       clk,
    input  wire       rst,
    input  wire       req_valid,
    input  wire [3:0] req_addr,
    output wire       req_ready,
    output reg        resp_valid,
    output reg  [7:0] resp_data,
    output reg        hit,
    output reg        miss
);

    localparam IDLE   = 2'd0;
    localparam LOOKUP = 2'd1;
    localparam REFILL = 2'd2;
    localparam RESP   = 2'd3;

    reg [1:0] state;

    // Main memory: 16 locations x 8 bits = 128 bits.
    reg [7:0] main_mem [0:15];

    // Cache: 4 lines x 8 data bits, plus 2-bit tag and valid bit per line.
    reg [7:0] cache_data [0:3];
    reg [1:0] cache_tag  [0:3];
    reg       cache_valid[0:3];

    reg [3:0] saved_addr;
    wire [1:0] requested_tag   = saved_addr[3:2];
    wire [1:0] requested_index = saved_addr[1:0];

    integer i;

    assign req_ready = (state == IDLE);

    // Example main-memory contents. Addresses 0 through 15 contain
    // distinct byte values so the testbench can easily identify them.
    initial begin
        main_mem[0]  = 8'h11;
        main_mem[1]  = 8'h22;
        main_mem[2]  = 8'hF0;
        main_mem[3]  = 8'h44;
        main_mem[4]  = 8'h55;
        main_mem[5]  = 8'h66;
        main_mem[6]  = 8'h77;
        main_mem[7]  = 8'h88;
        main_mem[8]  = 8'h99;
        main_mem[9]  = 8'hAA;
        main_mem[10] = 8'hBB;
        main_mem[11] = 8'hCC;
        main_mem[12] = 8'hDD;
        main_mem[13] = 8'hEE;
        main_mem[14] = 8'h0F;
        main_mem[15] = 8'hA5;
    end

    always @(posedge clk) begin
        if (rst) begin
            state      <= IDLE;
            saved_addr <= 4'd0;
            resp_data  <= 8'd0;
            resp_valid <= 1'b0;
            hit        <= 1'b0;
            miss       <= 1'b0;

            for (i = 0; i < 4; i = i + 1) begin
                cache_data[i]  <= 8'd0;
                cache_tag[i]   <= 2'd0;
                cache_valid[i] <= 1'b0;
            end
        end else begin
            // These are one-cycle event indicators.
            resp_valid <= 1'b0;
            hit        <= 1'b0;
            miss       <= 1'b0;

            case (state)
                IDLE: begin
                    if (req_valid) begin
                        saved_addr <= req_addr;
                        state      <= LOOKUP;
                    end
                end

                LOOKUP: begin
                    if (cache_valid[requested_index] &&
                        cache_tag[requested_index] == requested_tag) begin
                        // Cache hit: the requested byte is already present.
                        resp_data <= cache_data[requested_index];
                        hit       <= 1'b1;
                        state     <= RESP;
                    end else begin
                        // Cache miss: fetch the byte from main memory.
                        miss  <= 1'b1;
                        state <= REFILL;
                    end
                end

                REFILL: begin
                    // Fill the selected cache line with the requested byte.
                    cache_data[requested_index]  <= main_mem[saved_addr];
                    cache_tag[requested_index]   <= requested_tag;
                    cache_valid[requested_index] <= 1'b1;
                    resp_data                    <= main_mem[saved_addr];
                    state                        <= RESP;
                end

                RESP: begin
                    // Response is asserted for one cycle.
                    resp_valid <= 1'b1;
                    state      <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
