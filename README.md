# HY523 RISC-V
## RV32IC with support for stream transactions

### Instruction Decode
> input the pipeline register produced by IF stage (IF_STATE)
> output the pipeline register ID_STATE

1. Produce the correct control signals based on every instruction(ignore stalls)
2. Decode instructions based on the ISA.sv
