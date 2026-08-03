//This module is to show that all 3:1 design is also possible
module mux3to1 (
    input  wire i0,
    input  wire i1,
    input  wire i2,
    input  wire [1:0] sel,
    output reg  y
);

always @(*) begin
    case (sel)
        2'b00: y = i0;
        2'b01: y = i1;
        2'b10: y = i2;
        default: y = 1'b0;
    endcase
end

endmodule
