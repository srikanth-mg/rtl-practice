Design debouncer with an asynchronus input, filter the glitches & generate debounced rising-edge pulse

Constraint: 
1) 2-ff sync. for asnyc input
2) accept high only after 2 stable sample
3) output: debounced_level + debounced_rise_pulse

Approach: 
in order to convert the async input to sync, we need 2ff sync in order to reduce the metastability state. once it's done, we need to check that input signal need to be high minimum of 2 clk cycle, only then debounced level should go to 1. 
from that, using +ve edge detector for rising edge to get the output pulse

Lesson: 
"2 consecutive" = prev & current, not a counter.
Counter approach works but over-designed - adds unnecessary state.
