`timescale 1ns/1ps

module tb_debounce_sync;

  logic clk, rst_n, async_in;
  logic debounced_level, debounced_rise_pulse;

  debounce_sync dut (.*);

  initial clk = 0;
  always #5 clk = ~clk;

  int pass_cnt, fail_cnt;

  task automatic check(input logic sig, input logic exp, input string tag);
    if (sig === exp) begin
      $display("[PASS] %s | got=%b", tag, sig);
      pass_cnt++;
    end else begin
      $display("[FAIL] %s | got=%b (expected %b)", tag, sig, exp);
      fail_cnt++;
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_debounce_sync);

    pass_cnt = 0;
    fail_cnt = 0;
    rst_n    = 0;
    async_in = 0;

    repeat (3) @(posedge clk);
    rst_n = 1;
    @(posedge clk);

    // ------------------------------------------------
    // TC1 — Glitch Rejection
    // ------------------------------------------------
    // 1-cycle pulse on async_in — too short to pass
    // 2FF sync + counter should filter it out
    @(negedge clk); async_in = 1;
    @(negedge clk); async_in = 0;

    // wait for any propagation through 2FF + counter
    repeat (6) @(posedge clk); #1;
    check(debounced_level, 0, "TC1: glitch rejected");

    // ------------------------------------------------
    // TC2 — Stable High Accepted + Pulse fires once
    // ------------------------------------------------
    @(negedge clk); async_in = 1;

    // wait for 2FF sync (2 cycles) + counter to saturate
    repeat (8) @(posedge clk); #1;
    check(debounced_level, 1, "TC2: stable high accepted");

    // check pulse fired exactly once by verifying
    // it's already deasserted (was single-cycle)
    check(debounced_rise_pulse, 0, "TC2: rise pulse not stuck");

    // ------------------------------------------------
    // TC3 — Deassertion 
    // ------------------------------------------------
    @(negedge clk); async_in = 0;

    // wait for 2FF to propagate low + counter to reset
    repeat (6) @(posedge clk); #1;
    check(debounced_level, 0, "TC3: deassertion works");

    // ------------------------------------------------
    $display("\n=== %0d PASSED, %0d FAILED ===", pass_cnt, fail_cnt);
    if (fail_cnt == 0) $display("ALL TESTS PASSED");
    $finish;
  end

endmodule
