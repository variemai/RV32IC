/*****************************************************************************
 * The Instruction Fetch module, reads the instruction from the IMemory      *
 * and increases the PC writes the instruction to the PC pipeline register   *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/

module Ifetch (
    input clk,
    input [31:0] pc;
    output PipelineRegs::ID_STATE;
    );





/* Use pc to read from Imem
 * Write the contents of memory to ID_STATE.instruction
 * Write the pc to ID_STATE.pc
 */


endmodule //
