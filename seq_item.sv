class ether_seq_item extends uvm_sequence_item;

//Tx
rand bit [63:0] pkt_tx_data[$];
rand bit [2:0] pkt_tx_mod;
rand bit pkt_tx_val;
rand bit pkt_tx_sop;
rand bit pkt_tx_eop;
bit pkt_tx_full;

//Rx
rand bit pkt_rx_ren;
bit [63:0] pkt_rx_data[$];
bit [2:0] pkt_rx_mod;
bit pkt_rx_val;
bit pkt_rx_sop;
bit pkt_rx_eop;
bit pkt_rx_err;
bit pkt_rx_avail;

//Frame fields
rand bit [55:0] preamble;
rand bit [7:0] sfd;
rand bit [47:0] mac_dst_addr;
rand bit [47:0] mac_src_addr;
rand bit [7:0] payload[ ];
rand bit [15:0] ether_type;

`uvm_object_utils (ether_seq_item)

function new (string name="ether_seq_item");
super.new (name);
endfunction

endclass
