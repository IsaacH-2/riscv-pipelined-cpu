`timescale 1ns/1ps

module alu_tb;

logic [31:0] a, b;
logic [3:0] alu_ctrl;
logic [31:0] result;
logic zero;

alu dut (
    .a(a),
    .b(b),
    .alu_ctrl(alu_ctrl),
    .result(result),
    .zero(zero)
);

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, alu_tb);

    // ADD
    a = 10; b = 5; alu_ctrl = 4'b0000;
    #10;
    if (result !== 32'd15) $error("ADD failed: got %0d", result);

    // SUB
    alu_ctrl = 4'b0001;
    #10;
    if (result !== 32'd5) $error("SUB failed: got %0d", result);

    // AND
    alu_ctrl = 4'b0010;
    #10;
    if (result !== 32'd0) $error("AND failed: got %0d", result);

    // OR
    alu_ctrl = 4'b0011;
    #10;
    if (result !== 32'd15) $error("OR failed: got %0d", result);

    // SLT
    a = -1; b = 1; alu_ctrl = 4'b1000;
    #10;
    if (result !== 32'd1) $error("SLT failed: got %0d", result);

        // XOR
    a = 32'hF0F0F0F0; b = 32'h0FF00FF0; alu_ctrl = 4'b0100;
    #10;
    if (result !== 32'hFF00FF00) $error("XOR failed: got %h", result);

    // SLL
    a = 32'd1; b = 32'd4; alu_ctrl = 4'b0101;
    #10;
    if (result !== 32'd16) $error("SLL failed: got %0d", result);

    // SRL
    a = 32'd16; b = 32'd2; alu_ctrl = 4'b0110;
    #10;
    if (result !== 32'd4) $error("SRL failed: got %0d", result);

    // SRA
    a = -32'd8; b = 32'd1; alu_ctrl = 4'b0111;
    #10;
    if (result !== -32'd4) $error("SRA failed: got %0d", result);

    // zero flag after subtraction
    a = 32'd9; b = 32'd9; alu_ctrl = 4'b0001;
    #10;
    if (result !== 32'd0) $error("Zero-result SUB failed: got %0d", result);
    if (zero !== 1'b1) $error("Zero flag failed: got %b", zero);

    $display("All ALU tests passed.");
    $finish;
end

endmodule