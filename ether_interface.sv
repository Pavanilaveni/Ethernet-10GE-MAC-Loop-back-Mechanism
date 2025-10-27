interface ether_interface(
        input bit clk, input bit rst, input bit reset_xgmii_rx_n, input logic reset_xgmii_tx_n, input logic wb_rst_i);

    //TX signals
    logic [63:0] pkt_tx_data;
    logic [2:0] pkt_tx_mod;
    logic pkt_tx_val;
    logic pkt_tx_sop;
    logic pkt_tx_eop;
    logic pkt_tx_full;

//Rx
    logic pkt_rx_ren;
    logic [63:0] pkt_rx_data;
    logic [2:0] pkt_rx_mod;
    logic pkt_rx_val;
    logic pkt_rx_sop;
    logic pkt_rx_eop;
    logic pkt_rx_err;
    logic pkt_rx_avail;

//xgmii

    logic [63:0] xgmii_rxd;
    logic [7:0] xgmii_rxc;
    logic [63:0] xgmii_txd;
    logic [7:0] xgmii_txc;

    // Clocking block for driver
    clocking drv_cb @(posedge clk);
        default input #0 output #0;

        output pkt_tx_val;
        output pkt_tx_sop;
        output pkt_tx_eop;
        output pkt_tx_mod;
        output pkt_tx_data;
        input pkt_tx_full;
    
        input pkt_rx_val;
        input pkt_rx_sop;
        input pkt_rx_eop;
        input pkt_rx_mod;
        input pkt_rx_err;
        input pkt_rx_data;
        input pkt_rx_avail;
        output pkt_rx_ren;

        input xgmii_txd;
        input xgmii_txc;
        input xgmii_rxd;
        input xgmii_rxc;
    endclocking

    // Clocking block for monitor
    clocking mon_cb @(posedge clk);
        default input #0 output #0;

        input pkt_tx_val;
        input pkt_tx_sop;
        input pkt_tx_eop;
        input pkt_tx_mod;
        input pkt_tx_data;
        input pkt_tx_full;

        input pkt_rx_val;
        input pkt_rx_sop;
        input pkt_rx_eop;
        input pkt_rx_mod;
        input pkt_rx_err;
        input pkt_rx_data;
        input pkt_rx_avail;
        input pkt_rx_ren;

        input xgmii_txd;
        input xgmii_txc;
        input xgmii_rxd;
        input xgmii_rxc;
    endclocking

    //Modports
    modport drive(clocking drv_cb);
    modport mont(clocking mon_cb);

    //Data should not be zero when pkt_tx_val is high
    property valid_data;
        @(posedge clk) pkt_tx_val |-> (pkt_tx_data != 0);
    endproperty
    assert property (valid_data) else
        $error("Assertion Failed: data");

    // tx should not be full when valid signal is high
    property full;
        @(posedge clk) pkt_tx_data |-> !pkt_tx_full;
    endproperty
    assert property (full) else
        $error("Assertion Failed: full");

    //pkt_rx_eop should be high when mod signal is high
    property mod;
        @(posedge clk) pkt_rx_eop |-> pkt_rx_mod; //Provide range
    endproperty
    assert property (mod) else
        $display("Assertion Failed: mod");


endinterface

