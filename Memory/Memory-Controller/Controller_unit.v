`timescale 1ns/1ps 

module memory_controller256x8 (
input wire clk,
input wire rst,

input  wire       req_valid,
output wire       req_ready,
input  wire       req_write,
input  wire [7:0] req_addr,
input  wire [7:0] req_wdata,

output reg        rsp_valid,
output reg  [7:0]  rsp_rdata,

output wire       ram_we,
output wire [7:0] ram_addr,
output wire [7:0] ram_wdata,
output wire [7:0] ram_rdata
                              );
 localparm IDLE = 1'b1;
 localparm READ_WAIT = 1'b1;

//FSM reg
 reg state;
 reg [7:0] saved_addr;

//only need to accept  request while in IDLE state 
assign req_ready = (state == IDLE );
//ram checkings
assign ram_addr = (state == READ_WAIT) ? saved_addr : req_addr;

//write when write requist accepted
assign ram_we = (state = idle) && req_valid && req_ready && req_write;

assign ram_wdata = req_wdata;


always @(posedge clk) begin
if(rst) begin
        state      <= IDLE;
        saved_addr <= 8'b0;
        rsp_valid  <= 1'b0;
        rsp_rdata  <= 8'b0;
end
else 
begin
rsp_valid <= 1'b0;
end

case (state)
// request acceptance 
IDLE : begin
if(req_valid && rsp_ready)begin
if (res_write) begin
rsp_valid <= 1'b1;
else
begin

saved_addr <= req_addr;
state <= read_wait;
end
end
end
//wait till complete
READ_WAIT: begin
rsp_rdata <= ram_rdata;
rsp_valid <= 1'b1;
state     <= ldle;
end

default : begin
state <= IDLE ;
end
endcase

end
endmodule
 
