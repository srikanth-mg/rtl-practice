Implement an FSM to detect the serial pattern "10110" with a 1-cycle match pulse

Constraints:
1) Overlapping support
2) Active-low async reset behaviour with returns to IDLE state
3) State progress through matching

Approach:
Went with mealy FSM since that's when the output arrives when the required last bit arrives into the pattern. Overlapping support is given. 
mealy FSM = output depends on current input + current state
Even tho glitch propagation is possible than moore, output arrives 1 cycle earlier. 
Each state representation is done by binary encoding because of less number of flops -> less area -> less power consumption
