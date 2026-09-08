`timescale 1ns/1ps

module memory_1_dimension_tb;

    // ----------------------------------------
    // Testbench signals
    // ----------------------------------------

    reg clk;
    reg [7:0] data_in;
    reg wr_en;
    reg [2:0] addr;

    wire [7:0] data_out;


    // Loop variable
   integer i;


  
    // DUT Instantiation


    memory_1_dimension dut (
        .clk      (clk),
        .data_in  (data_in),
        .wr_en    (wr_en),
        .addr     (addr),
        .data_out (data_out)
    );



    // Clock Generation
    // Clock Period = 10 ns


    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end


    // Main Test Sequence


    initial begin

        // Initial values
        data_in = 8'd0;
        wr_en   = 0;
        addr    = 3'd0;


        $display("==================================");
        $display("STARTING WRITE OPERATION");
        $display("==================================");

        wr_en = 1;

        for (i = 0; i < 8; i = i + 1) begin

            addr    = i;
            data_in = i + 10;

            // Wait for one rising clock edge
            @(posedge clk);

            $display(
                "WRITE: Address = %0d | Data = %0d",
                addr,
                data_in
            );

        end


        // Disable write operation
        wr_en = 0;


        // WAIT FOR 2 CLOCK CYCLES

        $display("==================================");
        $display("WAITING FOR 2 CLOCK CYCLES");
        $display("==================================");

        repeat (2) @(posedge clk);



        // READ ALL 8 MEMORY LOCATIONS
        $display("==================================");
        $display("STARTING READ OPERATION");
        $display("==================================");

        for (i = 0; i < 8; i = i + 1) begin

            addr = i;

            // Small delay for asynchronous read
            #1;

            $display(
                "READ : Address = %0d | Data = %0d",
                addr,
                data_out
            );

            // Move to next cycle
            @(posedge clk);

        end

        $display("==================================");
        $display("TEST COMPLETED");
        $display("==================================");

        #10;

        $finish;

    end


    
    // Waveform Monitoring
    initial begin

        $monitor(
            "TIME = %0t | CLK = %b | WR_EN = %b | ADDR = %0d | DATA_IN = %0d | DATA_OUT = %0d",
            $time,
            clk,
            wr_en,
            addr,
            data_in,
            data_out
        );

    end
    
    initial begin
    $dumpfile("mem_op.vcd");
    $dumpvars(0, memory_1_dimension_tb);
end


endmodule
