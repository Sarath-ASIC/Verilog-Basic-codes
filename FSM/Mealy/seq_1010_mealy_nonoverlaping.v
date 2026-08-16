`timescale 1ns/1ps

module seq_detector_1010_mealy_nonoverlap (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output reg  detected
);

    parameter S0 = 2'b00,
              S1 = 2'b01,
              S2 = 2'b10,
              S3 = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state and Mealy output logic
    always @(*) begin

        next_state = S0;
        detected   = 1'b0;

        case (state)

            // No match
            S0: begin
                if (din)
                    next_state = S1;
                else
                    next_state = S0;
            end

            // Matched 1
            S1: begin
                if (din)
                    next_state = S1;
                else
                    next_state = S2;
            end

            // Matched 10
            S2: begin
                if (din)
                    next_state = S3;
                else
                    next_state = S0;
            end

            // Matched 101
            S3: begin
                if (din) begin
                    next_state = S1;
                end
                else begin
                    // 1010 detected
                    detected   = 1'b1;

                    // Return to S0 for non-overlapping detection
                    next_state = S0;
                end
            end

            default: begin
                next_state = S0;
                detected   = 1'b0;
            end

        endcase
    end

endmodule
