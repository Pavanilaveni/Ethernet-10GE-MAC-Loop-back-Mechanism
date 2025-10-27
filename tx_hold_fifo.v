`include "defines.v"

module tx_hold_fifo(/*AUTOARG*/
  // Outputs
  txhfifo_wfull, txhfifo_walmost_full, txhfifo_rdata, txhfifo_rstatus,
  txhfifo_rempty, txhfifo_ralmost_empty,
  // Inputs
  clk_xgmii_tx, reset_xgmii_tx_n, txhfifo_wdata, txhfifo_wstatus,
  txhfifo_wen, txhfifo_ren
  );

input         clk_xgmii_tx;
input         reset_xgmii_tx_n;

input [63:0]  txhfifo_wdata;
input [7:0]   txhfifo_wstatus;
input         txhfifo_wen;

input         txhfifo_ren;

output        txhfifo_wfull;
output        txhfifo_walmost_full;

output [63:0] txhfifo_rdata;
output [7:0]  txhfifo_rstatus;
output        txhfifo_rempty;
output        txhfifo_ralmost_empty;

generic_fifo #(
  .DWIDTH (72),
  .AWIDTH (`TX_HOLD_FIFO_AWIDTH),
  .REGISTER_READ (1),
  .EARLY_READ (1),
  .CLOCK_CROSSING (0),
  .ALMOST_EMPTY_THRESH (7),
  .ALMOST_FULL_THRESH (4),
  .MEM_TYPE (`MEM_AUTO_SMALL)
)
fifo0(
    .wclk (clk_xgmii_tx),
    .wrst_n (reset_xgmii_tx_n),
    .wen (txhfifo_wen),
    .wdata ({txhfifo_wstatus, txhfifo_wdata}),
    .wfull (txhfifo_wfull),
    .walmost_full (txhfifo_walmost_full),

    .rclk (clk_xgmii_tx),
    .rrst_n (reset_xgmii_tx_n),
    .ren (txhfifo_ren),
    .rdata ({txhfifo_rstatus, txhfifo_rdata}),
    .rempty (txhfifo_rempty),
    .ralmost_empty (txhfifo_ralmost_empty)
);

endmodule

