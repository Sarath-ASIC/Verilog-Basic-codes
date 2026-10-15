//----------------------------------------------
// TITLE  :ADDRESS DECODER
// SPECIFICATION : Decode a 7 bit input into 
//                 --> VALID
//                 --> TAG
//                 --> INDEX
//----------------------------------------------
`timescale 1ns/1ps
module address_decoder (

    input  wire [6:0] address,
    input  wire       valid,
    input  wire [2:0] stored_tag,

    output wire [2:0] requested_tag,
    output wire [1:0] index,
    output wire [1:0] offset,

    output wire       hit,
    output wire       miss
);

    // Decode the address
    assign requested_tag = address[6:4];
    assign index         = address[3:2];
    assign offset        = address[1:0];

    // Determine cache hit or miss
    assign hit  = valid && (requested_tag == stored_tag);
    assign miss = ~hit;

endmodule
