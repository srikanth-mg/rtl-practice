module reset_sync (
  input  logic clk,
  input  logic async_rst_n,
  output logic rst_n_sync
);

  logic r1, r2;

  always_ff @(posedge clk or negedge async_rst_n)begin
    if(!async_rst_n)begin
    r1 <= 1'b0;
    r2 <= 1'b0;
    end else begin
    r1 <= 1'b1;
    r2 <= r1;
    end
  end

  assign rst_n_sync = r2;

endmodule
