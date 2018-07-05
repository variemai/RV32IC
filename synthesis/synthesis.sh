source ~/lab3/common/scripts/common.tcl
set link_library          "$Std_cell_lib $Ram_lib"
set target_library        "$Std_cell_lib $Ram_lib"
analyze -format sverilog {mem_sync_sp_syn.sv reg_file_2r1w_syn.sv IFetch.sv Decoder.sv ID_EX_reg.sv alu.sv dmem.sv RegFile.sv top.sv}
elaborate top
link
check_design
read_sdc top.sdc
