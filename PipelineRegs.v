package PipelineRegs;

    typedef struct packed {
        logic [31:0] pc;
    }IF_STATE;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] instruction;
    }ID_STATE;

    typedef struct packed {
        logic [31:0] pc;
        logic alu_cntrl; //how many bits will we need here?
        logic [31:0] reg_data1;
        logic [31:0] reg_data2;
        logic [31:0] immediate; //not sure about this
        logic [4:0] reg_wb;
        logic alu_src;
        /*More signals for forwarding and hazard detection*/
        logic [4:0] reg_src1;
        logic [4:0] reg_src2;
    }EX_STATE;

endpackage
