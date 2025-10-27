`include "uvm_macros.svh"
import uvm_pkg::*;

`include "seq_item.sv"
`include "eth_seq.sv"
`include "ether_seqr.sv"
`include "eth_driver.sv"
`include "ether_interface.sv"
`include "eth_monitor.sv"
`include "eth_pas_mon.sv"
`include "ether_agent.sv"
`include "ether_pas_agent.sv"
`include "ether_scoreboard.sv"
`include "ether_subscriber.sv"
`include "ether_env.sv"
`include "ether_test.sv"
`include "xge_mac.v"

module top;
     bit clk,rst,reset_xgmii_rx_n,reset_xgmii_tx_n,wb_clk_i,wb_rst_i;
    bit wb_cyc_i;
    bit wb_stb_i;
    bit wb_we_i;
    bit [7:0]wb_adr_i;
    bit [31:0] wb_dat_i;
    bit [31:0]wb_dat_o;
    bit wb_ack_o;
    bit wb_int_o;
    bit [63:0] xgmii_rxd;
    bit [7:0] xgmii_rxc;
    bit [63:0] xgmii_txd;
    bit [7:0] xgmii_txc;

   ether_interface intf(clk,rst,reset_xgmii_rx_n,reset_xgmii_tx_n,wb_rst_i); 

    //connect interface to DUT using modport 'dut'

    xge_mac d1(
    .xgmii_txd(intf.xgmii_txd),
    .xgmii_txc(intf.xgmii_txc),
    .wb_int_o(wb_int_o),
    .wb_dat_o(wb_dat_o),
    .wb_ack_o(wb_ack_o), 
    .pkt_tx_full(intf.pkt_tx_full),
    .pkt_rx_val(intf.pkt_rx_val), 
    .pkt_rx_sop(intf.pkt_rx_sop), 
    .pkt_rx_mod(intf.pkt_rx_mod), 
    .pkt_rx_err(intf.pkt_rx_err), 
    .pkt_rx_eop(intf.pkt_rx_eop),
    .pkt_rx_data(intf.pkt_rx_data), 
    .pkt_rx_avail(intf.pkt_rx_avail),
    .xgmii_rxd(intf.xgmii_rxd), 
    .xgmii_rxc(intf.xgmii_rxc), 
    .wb_we_i(wb_we_i), 
    .wb_stb_i(wb_stb_i), 
    .wb_rst_i(wb_rst_i), 
    .wb_dat_i(wb_dat_i),
    .wb_cyc_i(wb_cyc_i), 
    .wb_clk_i(wb_clk_i), 
    .wb_adr_i(wb_adr_i), 
    .reset_xgmii_tx_n(reset_xgmii_tx_n), 
    .reset_xgmii_rx_n(reset_xgmii_rx_n),
    .reset_156m25_n(rst), 
    .pkt_tx_val(intf.pkt_tx_val), 
    .pkt_tx_sop(intf.pkt_tx_sop), 
    .pkt_tx_mod(intf.pkt_tx_mod), 
    .pkt_tx_eop(intf.pkt_tx_eop),
    .pkt_tx_data(intf.pkt_tx_data), 
    .pkt_rx_ren(intf.pkt_rx_ren), 
    .clk_xgmii_tx(intf.clk), 
    .clk_xgmii_rx(intf.clk), 
    .clk_156m25(intf.clk)
    );

    assign intf.xgmii_rxd = intf.xgmii_txd;
    assign intf.xgmii_rxc = intf.xgmii_txc;

   always #5 clk=~clk;
    
    initial begin
     clk=0;
    rst=0;
    reset_xgmii_rx_n = 0;
    reset_xgmii_tx_n = 0;
    wb_rst_i=1;
    #10;

    rst=1;
    reset_xgmii_rx_n = 1;
    reset_xgmii_tx_n = 1;
    wb_rst_i = 1;
    //#150; $finish;
    
    end

    initial begin
        run_test("ether_test");
    end

    initial begin
        uvm_config_db#(virtual ether_interface.drv_cb)::set(null,"*","intf",intf);
        uvm_config_db#(virtual ether_interface)::set(null,"*","intf",intf);

    end

endmodule
