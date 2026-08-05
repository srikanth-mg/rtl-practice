module tb;
  logic clk;
  logic rst_n;
  logic tick_1ms;
  logic sec_pulse;
  logic min_pulse;
  logic hour_pulse;
  int   p = 0, f = 0;

  initial clk = 0;
  always #5 clk = ~clk;

  timebase dut (.*);

  task send_tick();
    tick_1ms = 1;
    @(posedge clk); #1;
    tick_1ms = 0;
    @(posedge clk); #1;
  endtask

  initial begin
    rst_n = 0; tick_1ms = 0;
    @(posedge clk); @(posedge clk); rst_n = 1;

    // =========================================================
    // TC1 — Seconds (1000 tick_1ms → exactly one sec_pulse)
    // =========================================================
    begin
      int sec_count = 0;
      repeat (1000) begin
        if (sec_pulse) sec_count++;
        send_tick();
      end
      if (sec_pulse) sec_count++;

      if (sec_count == 1) begin p++; $display("PASS: TC1 seconds: got %0d sec_pulse", sec_count); end
      else begin f++; $display("FAIL: TC1 seconds: got %0d sec_pulse expected 1", sec_count); end
    end

    // =========================================================
    // TC2 — Minutes (60 sec_pulses → exactly one min_pulse)
    // =========================================================
    rst_n = 0; @(posedge clk); @(posedge clk); rst_n = 1;
    begin
      int min_count = 0;
      // 60 seconds = 60 * 1000 = 60000 ticks
      repeat (60000) begin
        if (min_pulse) min_count++;
        send_tick();
      end
      if (min_pulse) min_count++;

      if (min_count == 1) begin p++; $display("PASS: TC2 minutes: got %0d min_pulse", min_count); end
      else begin f++; $display("FAIL: TC2 minutes: got %0d min_pulse expected 1", min_count); end
    end

    $display("=== %0d passed %0d failed ===", p, f);
    $finish;
  end
endmodule
