module sram (
    input clk,
    input we,
    input [3:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    // 16 locations, each storing 8 bits
    reg [7:0] mem [0:15];

    // Write operation
    always @(posedge clk)
    begin
        if (we == 1)
        begin
            mem[address] <= data_in;
        end
    end

    // Read operation
    always @(*)
    begin
        if (we == 0)
        begin
            data_out = mem[address];
        end
    end

endmodule
