Implement an FSM with 3 remainder states that updates on each incoming bit & assert the output when the remainder is 0. 

Constraints:
1) Track only the remainder, not the full number
2) start at remainder 0

Approach: 
if we want to know which number are divisible by 3, we need to know what are the possible remainder for 3 -> which are 0, 1, 2. 
so these 3 can be the state -> s0, s1, s2
for each input 0 (or) 1, we need to find the transition aka destination state. 
so for that transistion => destination state = (2 x current state) % N (where N is the required divisble from the question) 
from that we can able to get the FSM state digaram. 

went with moore fsm = output depends on only the current state, 1 clk cycle latency, no glitch propagation, stable & correct output compare to mealy. 
