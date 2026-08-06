module clk_gate_tb;
  logic clk;
  logic en;
  logic gclk;
  int   p = 0, f = 0;

  initial clk = 0;
  always #5 clk = ~clk;

  clock_gate dut (.*);

  initial begin
    en = 0;
    @(posedge clk);

    // =========================================================
    // TC1 — Stable en=1: gclk follows clk for 4 cycles
    // =========================================================
    @(negedge clk); en = 1;
    begin
      int match = 0;
      repeat (4) begin
        @(posedge clk); #1;
        if (gclk === 1'b1) match++;
        @(negedge clk); #1;
        if (gclk === 1'b0) match++;
      end
      if (match == 8) begin p++; $display("PASS: TC1 stable en=1: gclk followed clk for 4 cycles"); end
      else begin f++; $display("FAIL: TC1 stable en=1: expected 8 matches got %0d", match); end
    end

    // =========================================================
    // TC2 — Stable en=0: gclk stays 0 for 4 cycles
    // =========================================================
    @(negedge clk); en = 0;
    begin
      int glitch = 0;
      repeat (4) begin
        @(posedge clk); #1;
        if (gclk !== 1'b0) glitch++;
        @(negedge clk); #1;
        if (gclk !== 1'b0) glitch++;
      end
      if (glitch == 0) begin p++; $display("PASS: TC2 stable en=0: gclk stayed 0"); end
      else begin f++; $display("FAIL: TC2 stable en=0: gclk glitched %0d times", glitch); end
    end

    // =========================================================
    // TC3 — Mid-cycle en toggle: no glitch while clk is high
    // =========================================================
    @(negedge clk); en = 0;
    @(posedge clk); #2;
    begin
      int glitch = 0;
      // clk is high — toggle en: 0 → 1 → 0
      en = 1; #2;
      if (gclk !== 1'b0) glitch++;
      en = 0; #2;
      if (gclk !== 1'b0) glitch++;

      if (glitch == 0) begin p++; $display("PASS: TC3 mid-cycle toggle: no glitch"); end
      else begin f++; $display("FAIL: TC3 mid-cycle toggle: glitch count=%0d", glitch); end
    end

    // =========================================================
    // TC4 — Enable captured at negedge: gclk high on next posedge
    // =========================================================
    @(negedge clk); en = 0;
    @(negedge clk);
    en = 1; // assert en while clk is low
    @(posedge clk); #1;
    if (gclk === 1'b1) begin p++; $display("PASS: TC4 negedge capture: gclk high on posedge"); end
    else begin f++; $display("FAIL: TC4 negedge capture: expected gclk=1 got %b", gclk); end

    $display("=== %0d passed %0d failed ===", p, f);
    $finish;
  end
endmodule
