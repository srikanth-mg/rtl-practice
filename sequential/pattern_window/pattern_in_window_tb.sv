`timescale 1ns/1ps

module tb_pattern_in_window;

  parameter N = 8;
  parameter K = 5;
  parameter [K-1:0] PATTERN = 5'b10110;

  logic clk, rst_n, bit_in, found;

  pattern_in_window #(.N(N), .K(K), .PATTERN(PATTERN)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .bit_in(bit_in),
    .found(found)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  int pass_cnt, fail_cnt;

  task automatic feed(input logic b);
    @(negedge clk);
    bit_in = b;
    @(posedge clk);
    #1;
  endtask

  task automatic check(input logic exp, input string tag);
    if (found === exp) begin
      $display("[PASS] %s | found=%b", tag, found);
      pass_cnt++;
    end else begin
      $display("[FAIL] %s | found=%b (expected %b)", tag, found, exp);
      fail_cnt++;
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_pattern_in_window);

    pass_cnt = 0;
    fail_cnt = 0;
    rst_n    = 0;
    bit_in   = 0;

    repeat (2) @(posedge clk);
    rst_n = 1;

    // ------------------------------------------------
    // TC1 — Feed pattern, expect found=1
    // ------------------------------------------------
    // shreg shifts right: {bit_in, shreg[N-1:1]}
    // Feed LSB-first: 0,1,1,0,1
    // After 5 clocks: shreg[7:3] = 10110 = PATTERN
    feed(0);
    feed(1);
    feed(1);
    feed(0);
    feed(1);
    check(1, "TC1: pattern inside window");

    // ------------------------------------------------
    // TC2 — Shift pattern out, expect found=0
    // ------------------------------------------------
    // Pattern slides from i=3 → 2 → 1 → 0 → out
    // 4 zeros flush it completely
    feed(0);
    feed(0);
    feed(0);
    feed(0);
    check(0, "TC2: pattern shifted out");

    // ------------------------------------------------
    $display("\n=== %0d PASSED, %0d FAILED ===", pass_cnt, fail_cnt);
    if (fail_cnt == 0) $display("ALL TESTS PASSED");
    $finish;
  end

endmodule
