`timescale 1ns/1ps

module memory_1_dimension_tb;

    // Testbench signals
    reg clk;
    reg [7:0] data_in;
    reg wr_en;
    reg [2:0] addr;

    wire [7:0] data_out;

    integer i;


    // DUT Instantiation
    memory_1_dimension dut (
        .clk      (clk),
        .data_in  (data_in),
        .wr_en    (wr_en),
        .addr     (addr),
        .data_out (data_out)
    );


    // Clock generation
    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end


    // Main stimulus
    initial begin
    
    $dumpfile("mem_op.vcd");
    $dumpvars(0,memory_1_dimension_tb);
     

        // Initial values
        wr_en   = 0;
        addr    = 0;
        data_in = 0;


        // ====================================
        // WRITE PHASE
        // ====================================

        $display("STARTING WRITE PHASE");


        for (i = 0; i < 8; i = i + 1) begin

            // Apply inputs at negative edge
            @(negedge clk);

            wr_en   = 1;
            addr    = i;
            data_in = i + 10;


            // DUT writes at next positive edge
            @(posedge clk);

        end


        // Disable write enable
        @(negedge clk);

        wr_en = 0;


        // ====================================
        // WAIT FOR 2 CYCLES
        // ====================================

        $display("WAITING FOR 2 CYCLES");

        repeat (2) @(posedge clk);


        // ====================================
        // READ PHASE
        // ====================================

        $display("STARTING READ PHASE");


        for (i = 0; i < 8; i = i + 1) begin

            @(negedge clk);

            addr = i;

            #1;

            $display(
                "Address = %0d | Data = %0d",
                addr,
                data_out
            );

        end


        #10;

        $finish;

    end

endmodule
