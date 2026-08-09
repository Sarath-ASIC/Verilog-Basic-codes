module tb_adder;

reg  [3:0] a;
reg  [3:0] b;
wire [4:0] sum;

reg [4:0] expected;

adder dut (
    .a(a),
    .b(b),
    .sum(sum)
);

initial begin

    // test case 1
    a = 4'd2;
    b = 4'd3;
    expected = a + b;

    #1;

    if (sum == expected)
        $display("PASS: a=%d b=%d sum=%d", a, b, sum);
    else
        $display("FAIL: a=%d b=%d sum=%d expected=%d",
                 a, b, sum, expected);


    //test case 2
    a = 4'd5;
    b = 4'd7;
    expected = a + b;

    #1;

    if (sum == expected)
        $display("PASS: a=%d b=%d sum=%d", a, b, sum);
    else
        $display("FAIL: a=%d b=%d sum=%d expected=%d",
                 a, b, sum, expected);


    // test case 3
    a = 4'd15;
    b = 4'd15;
    expected = a + b;

    #1;

    if (sum == expected)
        $display("PASS: a=%d b=%d sum=%d", a, b, sum);
    else
        $display("FAIL: a=%d b=%d sum=%d expected=%d",
                 a, b, sum, expected);

    $finish;

end

endmodule
