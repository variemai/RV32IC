source ~/lab3/common/scripts/common.tcl
set link_library          "$Std_cell_lib $Ram_lib"
set target_library        "$Std_cell_lib $Ram_lib"
analyze -format sverilog {imem.sv regfile.sv mem_sync_sp.sv alu.sv IFetch.sv Decoder.sv ID_EX_reg.sv dmem.sv RegFile.sv top.sv}
elaborate top
link
check_design
