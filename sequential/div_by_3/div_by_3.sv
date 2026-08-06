module div_by_3 (
  input  logic clk,
  input  logic rst_n,
  input  logic bit_in,
  output logic div_by_3
);

  typedef enum logic [1:0] {
                  S0 = 2'b00,
                  S1 = 2'b01,
                  S2 = 2'b10
  } state_t;

  state_t cs, ns;

  always_ff @(posedge clk or negedge rst_n)begin
    if(!rst_n)
    cs <= S0;
    else 
    cs <= ns;
  end

  always_comb begin
    ns = cs;
    case(cs)
    S0 : ns = bit_in ? S1 : S0;
    S1 : ns = bit_in ? S0 : S2;
    S2 : ns = bit_in ? S2 : S1;
    default : ns = S0;
    endcase
  end

assign div_by_3 = (cs == S0);     

endmodule
