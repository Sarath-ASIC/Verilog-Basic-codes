`timescale 1ns/1ps

module seq_detector_1010_moore (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output reg  detected
);

    // State encoding
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)

            S0: begin
                if (din)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (din)
                    next_state = S1;
                else
                    next_state = S2;
            end

            S2: begin
                if (din)
                    next_state = S3;
                else
                    next_state = S0;
            end

            S3: begin
                if (din)
                    next_state = S1;
                else
                    next_state = S4;
            end

            S4: begin
                // Detection completed.
                // Return to S0 for non-overlapping operation.
                next_state = S0;
            end

            default:
                next_state = S0;

        endcase
    end

    // Moore output logic
    always @(*) begin
        if (state == S4)
            detected = 1'b1;
        else
            detected = 1'b0;
    end

endmodule
