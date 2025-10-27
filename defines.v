
// CPU Registers

`define CPUREG_CONFIG0      8'h00
`define CPUREG_INT_PENDING  8'h08
`define CPUREG_INT_STATUS   8'h0c
`define CPUREG_INT_MASK     8'h10


// Ethernet codes

`define IDLE       8'h07
`define PREAMBLE   8'h55
`define SEQUENCE   8'h9c
`define SFD        8'hd5
`define START      8'hfb
`define TERMINATE  8'hfd
`define ERROR      8'hfe



`define LINK_FAULT_OK      2'd0
`define LINK_FAULT_LOCAL   2'd1
`define LINK_FAULT_REMOTE  2'd2

`define FAULT_SEQ_LOCAL  1'b0
`define FAULT_SEQ_REMOTE 1'b1

`define LOCAL_FAULT   8'd1
`define REMOTE_FAULT  8'd2

`define PAUSE_FRAME   48'h010000c28001

`define LANE0        7:0
`define LANE1       15:8
`define LANE2      23:16
`define LANE3      31:24
`define LANE4      39:32
`define LANE5      47:40
`define LANE6      55:48
`define LANE7      63:56


`define TXSTATUS_NONE       8'h0
`define TXSTATUS_EOP        3'd6
`define TXSTATUS_SOP        3'd7

`define RXSTATUS_NONE       8'h0
`define RXSTATUS_ERR        3'd5
`define RXSTATUS_EOP        3'd6
`define RXSTATUS_SOP        3'd7


//
// FIFO Size: 8 * (2^AWIDTH) will be the size in bytes
//            7 --> 128 entries, 1024 bytes for data fifo
//
`define TX_DATA_FIFO_AWIDTH 11
`define RX_DATA_FIFO_AWIDTH 11

//
// FIFO Size: Holding FIFOs are 16 deep
//
`define TX_HOLD_FIFO_AWIDTH 4
`define RX_HOLD_FIFO_AWIDTH 4


// Memory types
`define MEM_AUTO_SMALL 1
`define MEM_AUTO_MEDIUM 2


// Changed system packet interface to big endian (12/12/2009)
// Comment out to use legacy mode
//`define BIGENDIAN
