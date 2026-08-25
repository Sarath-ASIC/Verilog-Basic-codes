module simple_peripheral (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    input  wire        write_enable,
    output wire        led_out
);

    
    reg [31:0] control_reg;

    
    localparam CONTROL_ADDR = 32'h0000_0000;


    
    always @(posedge clk or posedge reset) begin

        if (reset) begin

            
            control_reg <= 32'h0000_0000;

        end
        else begin

            if (write_enable) begin

                
                if (address == CONTROL_ADDR) begin
                    control_reg <= write_data;

                end
            end

        end

    end


    // Connect bit 0 of the hardware register to output
    assign led_out = control_reg[0];

endmodule
