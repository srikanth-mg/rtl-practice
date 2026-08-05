# RTL Practice

Daily RTL design problems solved in SystemVerilog covering combinational logic, sequential circuits, CDC, FSMs, and memory structures. Each solution includes the design source, a self-checking testbench, and a short writeup explaining the approach.

---

## Repository Structure

```
rtl-practice/
├── combinational/       # Muxes, encoders, adders, decoders
├── sequential/          # Counters, shift registers, clock dividers
├── cdc/                 # Async FIFOs, synchronizers, Gray-coded logic
├── fsm/                 # Mealy, Moore, protocol controllers
├── memory/              # RAMs, register files, CAMs
└── arithmetic/          # ALUs, multipliers, dividers
```

Each problem folder contains:

| File           | Description                                      |
|----------------|--------------------------------------------------|
| `design.sv`    | Synthesizable RTL solution                       |
| `tb.sv`        | Self-checking testbench with pass/fail reporting  |
| `README.md`    | Problem summary, approach, and key takeaways      |

---

## Tools

- **Language:** SystemVerilog (IEEE 1800-2017)
- **Practice Platform:** LeetSilicon

---

## Author

Srikanth Muthuvel Ganthimathi
