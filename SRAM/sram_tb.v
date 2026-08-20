module sram_tb;

    reg clk;
    reg we;
    reg [3:0] address;
    reg [7:0] data_in;

    wire [7:0] data_out;

    // Instantiate SRAM
    sram uut (
        .clk(clk),
        .we(we),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial
    begin

        // Initial values
        clk = 0;
        we = 0;
        address = 0;
        data_in = 0;

        // --------------------------------
        // WRITE 1
        // --------------------------------

        #10;

        we = 1;
        address = 4'd3;
        data_in = 8'hAA;

        #10;

        // --------------------------------
        // READ 1
        // --------------------------------

        we = 0;
        address = 4'd3;

        #10;

        $display("Address = %d, Data = %h", address, data_out);

        // --------------------------------
        // WRITE 2
        // --------------------------------

        we = 1;
        address = 4'd7;
        data_in = 8'h55;

        #10;

        // --------------------------------
        // READ 2
        // --------------------------------

        we = 0;
        address = 4'd7;

        #10;

        $display("Address = %d, Data = %h", address, data_out);

        // --------------------------------
        // WRITE 3
        // --------------------------------

        we = 1;
        address = 4'd10;
        data_in = 8'hF0;

        #10;

        // --------------------------------
        // READ 3
        // --------------------------------

        we = 0;
        address = 4'd10;

        #10;

        $display("Address = %d, Data = %h", address, data_out);

        // Finish simulation
        $finish;

    end

endmodule
