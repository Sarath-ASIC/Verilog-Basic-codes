
module ddr_transmitter (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] data_in,
    output wire [7:0]  data_out
);

    reg [7:0] pos_data;
    reg [7:0] neg_data;

    // Positive-edge data capture
    always @(posedge clk or posedge rst) begin
        if (rst)
            pos_data <= 8'h00;
        else
            pos_data <= data_in[15:8];
    end

    // Negative-edge data capture
    always @(negedge clk or posedge rst) begin
        if (rst)
            neg_data <= 8'h00;
        else
            neg_data <= data_in[7:0];
    end

    // Select data according to clock level
    assign data_out = clk ? pos_data : neg_data;

endmodule
