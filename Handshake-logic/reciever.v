module receiver (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] data_in,
    input  wire       valid,
    output reg        ready,
    output reg [7:0]  received_data,
    output reg        received
);

    always @(posedge clk) begin
        if (rst) begin
            ready         <= 1'b0;
            received_data <= 8'd0;
            received      <= 1'b0;
        end
        else begin
            received <= 1'b0;

            // Receiver becomes ready
            ready <= 1'b1;

            // Accept data only when valid and ready
            if (valid && ready) begin
                received_data <= data_in;
                received      <= 1'b1;
                ready         <= 1'b0;
            end
        end
    end

endmodule
