module sq_detect (
  input  logic clk,
  input  logic rst_n,
  input  logic bit_in,
  output logic match_pulse
);

typedef enum logic [2:0] {
                S1 = 3'b000,
                S10 = 3'b001,
                S101 = 3'b010,
                S1011 = 3'b011,
                S10110 = 3'b100
} state_t;

state_t cs, ns;

always_ff @(posedge clk or negedge rst_n)begin
  if(!rst_n)
  cs <= S1;
  else
  cs <= ns;
end

always_comb begin
  ns = cs;
  case(cs)
  S1 : ns = (bit_in) ? S1 : S10;
  S10 : ns = (bit_in) ? S101 : S1;
  S101 : ns = (bit_in) ? S1011 : S10;
  S1011 : ns = (bit_in) ? S1 : S10110;
  S10110 : ns = (bit_in) ? S101 : S1;
  default : ns = S1;
  endcase
end

assign  match_pulse = ((cs == S1011) && !bit_in);

endmodule
