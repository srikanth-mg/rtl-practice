module debounce_sync (
  input  logic clk,
  input  logic rst_n,
  input  logic async_in,
  output logic debounced_level,
  output logic debounced_rise_pulse
);

  logic s1, s2;
  logic [1:0] count;
  logic debounce_d;

  always_ff @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      s1 <= 0;
      s2 <= 0;
    end else begin
      s1 <= async_in;
      s2 <= s1;
    end
  end
   
   always_ff @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      count <= '0;
      debounced_level <= 1'b0;
    end else if(count == 2'd2)begin
      count <= '0;
      debounced_level <= 1'b1;
    end else if(s2)
      count <= count + 1;
    else begin
      count <= '0;
      debounced_level <= 1'b0;
    end
   end

   always_ff @(posedge clk or negedge rst_n)begin
    if(!rst_n)
    debounce_d <= 0;
    else 
    debounce_d <= debounced_level;
   end

  assign debounced_rise_pulse = debounced_level & ~debounce_d;
endmodule
