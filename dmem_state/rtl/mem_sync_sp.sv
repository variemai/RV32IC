module mem_sync_sp #(
  parameter DEPTH       = 2048,
  parameter ADDR_WIDTH  = $clog2(DEPTH),
  parameter DATA_WIDTH  = 32,
  parameter DATA_BYTES  = DATA_WIDTH/8,
  parameter INIT_ZERO   = 0,
  parameter INIT_FILE   = "mem.hex",
  parameter INIT_START  = 0,
  parameter INIT_END    = DEPTH-1
) (
  input                         clk,
  input      [ADDR_WIDTH-1:0]   i_addr,
  input      [DATA_WIDTH-1:0]   i_wdata,
  input      [DATA_BYTES-1:0]   i_wen,
  output bit [DATA_WIDTH-1:0]   o_rdata
);

bit [DATA_WIDTH-1:0] mem [0 : DEPTH-1];

// WRITE_FIRST MODE
always @(posedge clk) begin
  for (int i=0 ; i<DATA_BYTES; i++) begin
    if ( i_wen[i] ) begin
      	//$display ("\t i_wen[%d] is: %d, val: %h\n", i, i_wen[i], i_wdata[8*i +: 8]);
	mem[i_addr][8*i +: 8] = i_wdata[8*i +: 8];
    end
  end

  o_rdata = mem[i_addr];
end

// initialize memory from file
initial begin
  if ( !INIT_ZERO ) begin
    $readmemh(INIT_FILE, mem, INIT_START, INIT_END);
  end
end

endmodule
