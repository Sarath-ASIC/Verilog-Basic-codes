module transmitter (
    input  wire       clk,
    input  wire       rst,
    input  wire       ready,
    output reg [7:0]  data_out,
    output reg        valid
);

    reg [7:0] data_reg;
    reg       pending;

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 8'd0;
            data_reg <= 8'd0;
            valid    <= 1'b0;
            pending  <= 1'b1;
        end
        else begin
            // Generate data only when no transaction is pending
            if (!pending) begin
                data_reg <= data_reg + 1'b1;
                pending  <= 1'b1;
            end

            // Hold valid and data until the receiver accepts them
            if (pending && (!valid || ready)) begin
                data_out <= data_reg;
                valid    <= 1'b1;
            end

            // Transfer completed
            if (valid && ready) begin
                valid   <= 1'b0;
                pending <= 1'b0;
            end
        end
    end

endmodule
