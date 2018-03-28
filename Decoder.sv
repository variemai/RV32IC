/*****************************************************************************
 * The Instruction Decoder module, creates the control signals,              *
 * reads from the register file and stores the information to EX_STATE reg   *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/
`include "PipelineRegs.v"
module decoder(
    input clk,
    input reset,
    input PipelineRegs::ID_STATE,
    output PipelineRegs::EX_STATE
    );

endmodule
