module memory_1_dimension (
    input wire clk,
    input wire [7:0] data_in,
    input wire wr_en,
    input wire [2:0] addr,
    output wire [7:0] data_out
);

    // Memory declaration:
    // 8 locations, each location stores 8 bits
    reg [7:0] mem [0:7];

    // Write operation
    always @(posedge clk) begin
        if (wr_en) begin
            mem[addr] <= data_in;
        end
    end

    // Read operation
    assign data_out = mem[addr];

endmodule
