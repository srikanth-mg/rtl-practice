module pattern_in_window #(
  parameter  N = 8,
  parameter  K = 5,
  parameter [K-1:0] PATTERN = 5'b10110
 )(
  input  logic clk,
  input  logic rst_n,
  input  logic bit_in,
  output logic found
);
  logic [N-1:0] shreg;

  always_ff @(posedge clk or negedge rst_n)begin
    if(!rst_n)
    shreg <= '0;
    else if(N >= K)
    shreg <= {bit_in, shreg[N-1:1]};
  end

  if(N >= K)begin : g_valid
  always_comb begin
      found = 1'b0;
    for(int i = 0; i < (N-K+1); i = i+1)begin
      if((shreg[i+:K] == PATTERN))begin
      found = 1'b1;
    end 
  end 
  end
  end else begin : g_invalid
    assign found = 1'b0;
  end
  
  endmodule
