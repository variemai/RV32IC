# HY523 RISC-V
## RV32IC with support for stream transactions

### Instruction Decode
> input the pipeline register produced by IF stage (IF_STATE)
> output the pipeline register ID_STATE


1. Instruction memory can be implemented as a test module in the first place.
2. Create a class Imem.v to emulate the behaviour of Imemory? 
3. Produce the correct control signals based on every instruction(ignore stalls)
4. Decode instructions based on the ISA.sv
