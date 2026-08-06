Detect pattern "10110" anywhere in last N samples using an N-bit shift register & combinational decode to detect a K-bit pattern at any alignment

Constraints:
1) Parameterizable N(window size), K =5, PATTERN = 5'b10110
2) Input comes from LSB to MSB inside the window
3) if the pattern is present inside the window -> found = 1
otherwise found = 0

Approach:
need to get the input into the shift register only if the window size atleast the value of K, otherwise no way to check with the PATTERN. 
need a for loop to go through the window starting from LSB to K & keep on slide the window & compare with the PATTERN. 
I did the for loop with generate block since the value of N & K are parameterizethe required hardware will be varied. So which can be got in elaboration time itself, if we go with generate block. 

whereas normal for loop: create the required hardware in simulation time which is less efficient than elaboration time. 


