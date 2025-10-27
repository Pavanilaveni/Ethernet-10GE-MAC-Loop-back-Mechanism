`include "defines.v"

module tx_data_fifo(/*AUTOARG*/
  // Outputs
  txdfifo_wfull, txdfifo_walmost_full, txdfifo_rdata, txdfifo_rstatus,
  txdfifo_rempty, txdfifo_ralmost_empty,
  // Inputs
  clk_xgmii_tx, clk_156m25, reset_xgmii_tx_n, reset_156m25_n,
  txdfifo_wdata, txdfifo_wstatus, txdfifo_wen, txdfifo_ren
  );

input         clk_xgmii_tx;
input         clk_156m25;
input         reset_xgmii_tx_n;
input         reset_156m25_n;

input [63:0]  txdfifo_wdata;
input [7:0]   txdfifo_wstatus;
input         txdfifo_wen;

input         txdfifo_ren;

output        txdfifo_wfull;
output        txdfifo_walmost_full;

output [63:0] txdfifo_rdata;
output [7:0]  txdfifo_rstatus;
output        txdfifo_rempty;
output        txdfifo_ralmost_empty;

generic_fifo #(
  .DWIDTH (72),
  .AWIDTH (`TX_DATA_FIFO_AWIDTH),
  .REGISTER_READ (1),
  .EARLY_READ (1),
  .CLOCK_CROSSING (1),
  .ALMOST_EMPTY_THRESH (7),
  .ALMOST_FULL_THRESH (12),
  .MEM_TYPE (`MEM_AUTO_MEDIUM)
)
fifo0(
    .wclk (clk_156m25),
    .wrst_n (reset_156m25_n),
    .wen (txdfifo_wen),
    .wdata ({txdfifo_wstatus, txdfifo_wdata}),
    .wfull (txdfifo_wfull),
    .walmost_full (txdfifo_walmost_full),

    .rclk (clk_xgmii_tx),
    .rrst_n (reset_xgmii_tx_n),
    .ren (txdfifo_ren),
    .rdata ({txdfifo_rstatus, txdfifo_rdata}),
    .rempty (txdfifo_rempty),
    .ralmost_empty (txdfifo_ralmost_empty)
);

endmodule
