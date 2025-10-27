`include "defines.v"

module rx_hold_fifo(/*AUTOARG*/
  // Outputs
  rxhfifo_rdata, rxhfifo_rstatus, rxhfifo_rempty,
  rxhfifo_ralmost_empty,
  // Inputs
  clk_xgmii_rx, reset_xgmii_rx_n, rxhfifo_wdata, rxhfifo_wstatus,
  rxhfifo_wen, rxhfifo_ren
  );

input         clk_xgmii_rx;
input         reset_xgmii_rx_n;

input [63:0]  rxhfifo_wdata;
input [7:0]   rxhfifo_wstatus;
input         rxhfifo_wen;

input         rxhfifo_ren;

output [63:0] rxhfifo_rdata;
output [7:0]  rxhfifo_rstatus;
output        rxhfifo_rempty;
output        rxhfifo_ralmost_empty;

generic_fifo #(
  .DWIDTH (72),
  .AWIDTH (`RX_HOLD_FIFO_AWIDTH),
  .REGISTER_READ (1),
  .EARLY_READ (1),
  .CLOCK_CROSSING (0),
  .ALMOST_EMPTY_THRESH (7),
  .MEM_TYPE (`MEM_AUTO_SMALL)
)
fifo0(
    .wclk (clk_xgmii_rx),
    .wrst_n (reset_xgmii_rx_n),
    .wen (rxhfifo_wen),
    .wdata ({rxhfifo_wstatus, rxhfifo_wdata}),
    .wfull (),
    .walmost_full (),

    .rclk (clk_xgmii_rx),
    .rrst_n (reset_xgmii_rx_n),
    .ren (rxhfifo_ren),
    .rdata ({rxhfifo_rstatus, rxhfifo_rdata}),
    .rempty (rxhfifo_rempty),
    .ralmost_empty (rxhfifo_ralmost_empty)
);

   
endmodule

