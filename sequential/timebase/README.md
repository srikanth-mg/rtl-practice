Generate Second/Minute/Hour pulse from 1ms tick using counter driven by 1ms pulse to generate derived timebase pulse

Constraints:
1) Each pulse is 1 cycle wide at rollover
2) Cascaded counter

Approach:
declare internal register for the counter with appropiate width declaration for each counter with specific condition for wrap & increment. 
