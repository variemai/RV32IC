`timescale 1ns/100fs

module reg_file_2r1w_syn #(
  parameter DEPTH       = 32,
  parameter ADDR_WIDTH  = $clog2(DEPTH),
  parameter DATA_WIDTH  = 32,
  parameter DATA_BYTES  = DATA_WIDTH/8
) (
  input                         clk,

  input      [ADDR_WIDTH-1:0]   i_addrA,
  input      [ADDR_WIDTH-1:0]   i_addrB,

  input      [ADDR_WIDTH-1:0]   i_waddr,
  input      [DATA_WIDTH-1:0]   i_wdata,
  input                         i_wen,

  output bit [DATA_WIDTH-1:0]   o_rdataA,
  output bit [DATA_WIDTH-1:0]   o_rdataB
);


SRAM2RW32x32 sram00 ( .CE1(clk), .OEB1(1'b0), .CSB1( 1'b0 ), .WEB1(1'b1),   .A1(i_addrA), .I1(32'b0),          .O1(o_rdataA[31: 0]) ,
                      .CE2(clk), .OEB2(1'b1), .CSB2( 1'b0 ), .WEB2(~i_wen), .A2(i_waddr), .I2(i_wdata[31: 0]), .O2()                );

SRAM2RW32x32 sram01 ( .CE1(clk), .OEB1(1'b0), .CSB1( 1'b0 ), .WEB1(1'b1),   .A1(i_addrB), .I1(32'b0),          .O1(o_rdataB[31: 0]) ,
                      .CE2(clk), .OEB2(1'b1), .CSB2( 1'b0 ), .WEB2(~i_wen), .A2(i_waddr), .I2(i_wdata[31: 0]), .O2()                );

generate
  if ( DATA_WIDTH == 64 ) begin
    SRAM2RW32x32 sram10 ( .CE1(clk), .OEB1(1'b0), .CSB1( 1'b0 ), .WEB1(1'b1),   .A1(i_addrA), .I1(32'b0),          .O1(o_rdataA[63:32]) ,
			  .CE2(clk), .OEB2(1'b1), .CSB2( 1'b0 ), .WEB2(~i_wen), .A2(i_waddr), .I2(i_wdata[63:32]), .O2()                );

    SRAM2RW32x32 sram11 ( .CE1(clk), .OEB1(1'b0), .CSB1( 1'b0 ), .WEB1(1'b1),   .A1(i_addrB), .I1(32'b0),          .O1(o_rdataB[63:32]) ,
			  .CE2(clk), .OEB2(1'b1), .CSB2( 1'b0 ), .WEB2(~i_wen), .A2(i_waddr), .I2(i_wdata[63:32]), .O2()                );
  end
endgenerate


endmodule
