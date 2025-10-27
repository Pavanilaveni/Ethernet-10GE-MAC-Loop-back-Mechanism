//`include "meta_sync.v"
//`include "meta_sync_single.v"

`include "sync_clk_core.v"
`include "sync_clk_wb.v"
`include "sync_clk_xgmii_tx.v"

`include "generic_fifo.v"

`include "tx_enqueue.v"
`include "tx_data_fifo.v"
`include "tx_dequeue.v"
`include "tx_hold_fifo.v"

`include "fault_sm.v"
`include "wishbone_if.v"

`include "rx_dequeue.v"
`include "rx_data_fifo.v"
`include "rx_enqueue.v"
`include "rx_hold_fifo.v"
