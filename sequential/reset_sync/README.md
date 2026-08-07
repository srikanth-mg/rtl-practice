Implement reset circuitry that assert asynchronously but deassert synchronous using a 2-flop synchronizer chain

Constraints: 
1) Assert: Immediately when async_rst_n goes low
2) Deassert: Only on clock edge(s) after release
3) 2-flop chain for synchronous deassert

Approach:
async assert the reset & sync de-assert the reset using 2-ff so that it will de-assert using positive clk edge. 
for assert, directly we can without 2ff, so that it can reflect at the output insame time 
