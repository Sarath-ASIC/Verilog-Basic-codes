module mux4to1 (
    input  wire [3:0] I,     // 4 input lines
    input  wire [1:0] S,     // 2-bit select
    output reg Y             // Output
);

always @(*) begin
    case (S)
        2'b00: Y = I[0];
        2'b01: Y = I[1];
        2'b10: Y = I[2];
        2'b11: Y = I[3];
        default: Y = 1'b0;
    endcase
end

endmodule
