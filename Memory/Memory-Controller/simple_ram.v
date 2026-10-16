`timescale 1ns/1ps

module memory256x8 (
 input wire       clk,
 input wire       we,
 input wire [7:0] addr,
 input wire [7:0] wdata,
 output reg [7:0] rdata
                   );
                  
                  reg [7:0] mem[0:255];
                  //sync write
                  always@(posedge clk)begin
                  
                  if(we) begin
                  mem[addr] <= wdata;
                  rdata <= mem[addr];
                  end
                  
                  end
                  endmodule
                  
                  
            
