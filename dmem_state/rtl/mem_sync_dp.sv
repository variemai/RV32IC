
module mem_sync_dp #(
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

  input      [ADDR_WIDTH-1:0]   i_addrA,
  input      [DATA_WIDTH-1:0]   i_wdataA,
  input      [DATA_BYTES-1:0]   i_wenA,
  output bit [DATA_WIDTH-1:0]   o_rdataA,

  input      [ADDR_WIDTH-1:0]   i_addrB,
  input      [DATA_WIDTH-1:0]   i_wdataB,
  input      [DATA_BYTES-1:0]   i_wenB,
  output bit [DATA_WIDTH-1:0]   o_rdataB
);

bit [DATA_WIDTH-1:0] mem [0 : DEPTH-1];

// WRITE_FIRST MODE
always @(posedge clk) begin
  for (int i=0 ; i<DATA_BYTES; i++) begin
    if ( i_wenA[i] ) begin
      mem[i_addrA][8*i +: 8] = i_wdataA[8*i +: 8];
    end
  end

  o_rdataA = mem[i_addrA];

  for (int i=0 ; i<DATA_BYTES; i++) begin
    if ( i_wenB[i] ) begin
      mem[i_addrB][8*i +: 8] = i_wdataB[8*i +: 8];
    end
  end

  o_rdataB = mem[i_addrB];
end

// initialize memory from file
initial begin
  if ( !INIT_ZERO ) begin
    $readmemh(INIT_FILE, mem, INIT_START, INIT_END);
  end
end

endmodule
