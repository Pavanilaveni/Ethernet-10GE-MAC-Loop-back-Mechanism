class ether_subscriber extends uvm_subscriber#(ether_seq_item);

`uvm_component_utils(ether_subscriber)
 uvm_analysis_imp #(ether_seq_item, ether_subscriber) analysis_export;
    logic pkt_tx_val;
    logic pkt_tx_sop;
    logic pkt_tx_eop;
    logic [2:0]pkt_tx_mod;

    bit [55:0] preamble;
    bit [7:0] sfd;
    bit [7:0] payload[];

    covergroup tx_cg1;
        coverpoint pkt_tx_val { bins valid = {[1:0]}; }
        coverpoint pkt_tx_sop { bins sop = {[1:0]}; }
        coverpoint pkt_tx_eop { bins eop = {[1:0]}; }
        coverpoint pkt_tx_mod { bins mod = {[7:0]}; }
    endgroup

    covergroup eth_frame_cg;
        coverpoint preamble {
            bins standard =  {56'h55555555555555};
            bins invalid = default; 
            }
        coverpoint sfd {
            bins standard = {8'hD5};
            bins invalid = default;
            }
        coverpoint payload.size(){
            bins runt = {[0:45]};
            //bins normal = {[46:1500]};
            //bins jumbo = {[1501:9000]};
            //illegal_bins oversize = {[9001:$]};
            }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name,parent);
        tx_cg1 = new();
        eth_frame_cg = new();
        analysis_export = new("analysis_export", this);
    endfunction

    function void write(ether_seq_item t);
    logic [15:0] zero_pad;

        //Directly access first 3 words from pkt_tx_data
        preamble = t.pkt_tx_data[0][63:8];
        sfd = t.pkt_tx_data[0][7:0];

        //mac_dst_addr = t.pkt_tx_data[1][63:16];
        //mac_src_addr[47:32] = t.pkt_tx_data[1][15:0];
        
        //mac_src_addr[31:0] = t.pkt_tx_data[2][63:32];
        //ether_type = t.pkt_tx_data[2][31:16];
        //zero_pad = t.pkt_tx_data[2][15:0];
        
        //Transaction signals
        pkt_tx_val = t.pkt_tx_val;
        pkt_tx_sop = t.pkt_tx_sop;
        pkt_tx_eop = t.pkt_tx_eop;
        pkt_tx_mod = t.pkt_tx_mod;

        //Payload data
        payload = t.payload;

        //Sample covergroups
        tx_cg1.sample();
        eth_frame_cg.sample();
    endfunction

endclass

