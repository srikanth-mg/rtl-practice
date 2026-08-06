Latch-based Integrated Clock Gating Cell (ICG Cell)

Constraint: 
1) en transparent when clk = 0, opague in clk = 1
2) i/p: clk, en
3) o/p: gclk

Approach: 
Need to use negative level latch for ICG, so that the EN can be changed but onceit goes to positive level, EN need to be freezed, so no glitch will be propagated into the circuit. 
