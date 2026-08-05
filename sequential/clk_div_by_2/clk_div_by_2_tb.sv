module tb;
  logic clk;
  logic rst_n;
  logic clk_div2;
  int   p = 0, f = 0;

  initial clk = 0;
  always #5 clk = ~clk;

  clk_div2 dut (.*);

  initial begin
    rst_n = 0;
    @(posedge clk); @(posedge clk); rst_n = 1;

    // =========================================================
    // TC1 — Toggle Check (output toggles every input clk cycle)
    // =========================================================
    begin
      int toggle_count = 0;
      logic prev = clk_div2;
      repeat (20) begin
        @(posedge clk); #1;
        if (clk_div2 !== prev) toggle_count++;
        prev = clk_div2;
      end
      if (toggle_count == 20) begin p++; $display("PASS: TC1 toggle: %0d toggles in 20 clocks", toggle_count); end
      else begin f++; $display("FAIL: TC1 toggle: got %0d expected 20", toggle_count); end
    end

    // =========================================================
    // TC2 — Reset (clk_div2 goes low on assert, resumes on deassert)
    // =========================================================
    rst_n = 0; @(posedge clk); @(posedge clk); #1;
    if (clk_div2 === 1'b0) begin p++; $display("PASS: TC2 reset assert: clk_div2=0"); end
    else begin f++; $display("FAIL: TC2 reset assert: expected 0 got %b", clk_div2); end
    rst_n = 1;
    @(posedge clk); @(posedge clk); @(posedge clk); #1;
    if (clk_div2 === 1'b1) begin p++; $display("PASS: TC3 reset deassert: clk_div2 resumed toggling"); end
    else begin f++; $display("FAIL: TC3 reset deassert: expected 1 got %b", clk_div2); end

    $display("=== %0d passed %0d failed ===", p, f);
    $finish;
  end
endmodule
