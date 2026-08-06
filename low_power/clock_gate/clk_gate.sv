module clk_gate (
  input  logic clk,
  input  logic en,
  output logic gclk
);
logic latched_en;

always_latch begin
  if(!clk)
  latched_en = en;
end

assign gclk = latched_en & clk;

endmodule
