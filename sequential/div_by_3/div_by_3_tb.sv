`timescale 1ns/1ps

module div_by_3_tb;

  logic clk, rst_n, bit_in, div_by_3;

  div_by_3 dut (.*);

  initial clk = 0;
  always #5 clk = ~clk;

  int pass_cnt, fail_cnt;

  task automatic feed(input logic b);
    @(negedge clk);
    bit_in = b;
    @(posedge clk);
    #1;
  endtask

  task automatic reset_dut();
    @(negedge clk);
    rst_n = 0;
    repeat (2) @(posedge clk);
    @(negedge clk);
    rst_n = 1;
  endtask

  task automatic check(input logic exp, input string tag);
    if (div_by_3 === exp) begin
      $display("[PASS] %s | div_by_3=%b", tag, div_by_3);
      pass_cnt++;
    end else begin
      $display("[FAIL] %s | div_by_3=%b (expected %b)", tag, div_by_3, exp);
      fail_cnt++;
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_div_by_3);

    pass_cnt = 0;
    fail_cnt = 0;
    rst_n    = 0;
    bit_in   = 0;

    repeat (2) @(posedge clk);
    rst_n = 1;
    @(posedge clk);

    // ------------------------------------------------
    // TC1 — 6 (0b110), divisible by 3
    // ------------------------------------------------
    // MSB first: 1, 1, 0
    // S0 →1→ S1 →1→ S0 →0→ S0
    feed(1);
    feed(1);
    feed(0);
    check(1, "TC1: 6 (0b110) divisible");

    // ------------------------------------------------
    // TC2 — 4 (0b100), not divisible by 3
    // ------------------------------------------------
    reset_dut();
    // MSB first: 1, 0, 0
    // S0 →1→ S1 →0→ S2 →0→ S1
    feed(1);
    feed(0);
    feed(0);
    check(0, "TC2: 4 (0b100) not divisible");

    // ------------------------------------------------
    // TC3 — Reset puts FSM in remainder-0 state
    // ------------------------------------------------
    reset_dut();
    #1;
    check(1, "TC3: after reset, FSM at S0");

    // ------------------------------------------------
    $display("\n=== %0d PASSED, %0d FAILED ===", pass_cnt, fail_cnt);
    if (fail_cnt == 0) $display("ALL TESTS PASSED");
    $finish;
  end

endmodule
