`include "defines.v"

module rx_data_fifo(/*AUTOARG*/
  // Outputs
  rxdfifo_wfull, rxdfifo_rdata, rxdfifo_rstatus, rxdfifo_rempty,
  rxdfifo_ralmost_empty,
  // Inputs
  clk_xgmii_rx, clk_156m25, reset_xgmii_rx_n, reset_156m25_n,
  rxdfifo_wdata, rxdfifo_wstatus, rxdfifo_wen, rxdfifo_ren
  );

input         clk_xgmii_rx;
input         clk_156m25;
input         reset_xgmii_rx_n;
input         reset_156m25_n;

input [63:0]  rxdfifo_wdata;
input [7:0]   rxdfifo_wstatus;
input         rxdfifo_wen;

input         rxdfifo_ren;

output        rxdfifo_wfull;

output [63:0] rxdfifo_rdata;
output [7:0]  rxdfifo_rstatus;
output        rxdfifo_rempty;
output        rxdfifo_ralmost_empty;

generic_fifo #(
  .DWIDTH (72),
  .AWIDTH (`RX_DATA_FIFO_AWIDTH),
  .REGISTER_READ (0),
  .EARLY_READ (1),
  .CLOCK_CROSSING (1),
  .ALMOST_EMPTY_THRESH (4),
  .MEM_TYPE (`MEM_AUTO_MEDIUM)
)
fifo0(
    .wclk (clk_xgmii_rx),
    .wrst_n (reset_xgmii_rx_n),
    .wen (rxdfifo_wen),
    .wdata ({rxdfifo_wstatus, rxdfifo_wdata}),
    .wfull (rxdfifo_wfull),
    .walmost_full (),

    .rclk (clk_156m25),
    .rrst_n (reset_156m25_n),
    .ren (rxdfifo_ren),
    .rdata ({rxdfifo_rstatus, rxdfifo_rdata}),
    .rempty (rxdfifo_rempty),
    .ralmost_empty (rxdfifo_ralmost_empty)
);

   
endmodule

