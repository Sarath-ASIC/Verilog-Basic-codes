//-----------------------------------------------------------
// TITLE       : Cache memory design - 1D
// SPECFICATION: 
//               Data width = 32 bits
//               Locations  = 512 Locations
// OPERATION   :
//               Writing = Synchronous
//               Reading = Asynchronous
// -----------------------------------------------------------

`timescale 1ns/1ps

module memory_512x32 ( 
   input wire         clk,
   input wire         we ,
   input wire  [8:0]  addr,  //512 locations (2^8); 
   input wire  [31:0] data_in, // 32 bit data_in;
   output reg  [31:0] data_out  // 32 bit data_out , Asynchronous;
); 

reg [31:0] mem [0:511];

// synchronous with clock design 
// 32 bit width and 512 location cache memory 
always @( posedge clk)
begin
if(we) 
mem[addr] <= data_in;
end

//asynchronous readouts
assign mem[addr] = data_out;

endmodule
