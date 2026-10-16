
module memory_top (
    input  wire       clk,
    input  wire       rst,

    // Request interface
    input  wire       req_valid,
    output wire       req_ready,
    input  wire       req_write,
    input  wire [7:0] req_addr,
    input  wire [7:0] req_wdata,

    // Response interface
    output wire       rsp_valid,
    output wire [7:0] rsp_rdata
);

    // Internal connections between controller and RAM
    wire       ram_we;
    wire [7:0] ram_addr;
    wire [7:0] ram_wdata;
    wire [7:0] ram_rdata;

    // Controller instance
    memory_controller u_controller (
        .clk       (clk),
        .rst       (rst),

        .req_valid (req_valid),
        .req_ready (req_ready),
        .req_write (req_write),
        .req_addr  (req_addr),
        .req_wdata (req_wdata),

        .rsp_valid (rsp_valid),
        .rsp_rdata (rsp_rdata),

        .ram_we    (ram_we),
        .ram_addr  (ram_addr),
        .ram_wdata (ram_wdata),
        .ram_rdata (ram_rdata)
    );

    // RAM instance
    simple_ram u_ram (
        .clk   (clk),
        .we    (ram_we),
        .addr  (ram_addr),
        .wdata (ram_wdata),
        .rdata (ram_rdata)
    );

endmodule
