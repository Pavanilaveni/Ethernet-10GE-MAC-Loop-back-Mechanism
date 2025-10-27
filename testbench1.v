`timescale 1ns / 1ps

module testbench;

  // Clock and reset
  reg clk_156m25 = 0;
  reg clk_xgmii_tx = 0;
  reg clk_xgmii_rx = 0;
  reg reset_156m25_n = 0;
  reg reset_xgmii_tx_n = 0;
  reg reset_xgmii_rx_n = 0;

  // XGMII RX inputs
  wire [63:0] xgmii_rxd;
  wire [7:0] xgmii_rxc;

  // Packet TX interface
  reg pkt_tx_val = 0;
  reg pkt_tx_sop = 0;
  reg pkt_tx_eop = 0;
  reg [2:0] pkt_tx_mod = 3'd0;
  reg [63:0] pkt_tx_data = 64'h0;

  // Packet RX interface
  wire pkt_rx_val;
  wire pkt_rx_sop;
  wire pkt_rx_eop;
  wire [2:0] pkt_rx_mod;
  wire pkt_rx_err;
  wire [63:0] pkt_rx_data;
  wire pkt_rx_avail;
  reg pkt_rx_ren = 0;

  // Wishbone interface
  reg wb_clk_i = 0;
  reg wb_rst_i = 0;
  reg wb_cyc_i = 0;
  reg wb_stb_i = 0;
  reg wb_we_i = 0;
  reg [7:0] wb_adr_i = 0;
  reg [31:0] wb_dat_i = 0;
  wire [31:0] wb_dat_o;
  wire wb_ack_o;
  wire wb_int_o;

  // XGMII TX outputs
  wire [63:0] xgmii_txd;
  wire [7:0] xgmii_txc;

  // TX flow control
  wire pkt_tx_full;

  // Clock generation
  always #3.2 clk_156m25 = ~clk_156m25;     // ~312.5 MHz
  always #3.2 clk_xgmii_tx = ~clk_xgmii_tx;
  always #3.2 clk_xgmii_rx = ~clk_xgmii_rx;
  always #5 wb_clk_i = ~wb_clk_i;           // 100 MHz

  // DUT instantiation
  xge_mac dut (
    .clk_156m25(clk_156m25),
    .clk_xgmii_tx(clk_xgmii_tx),
    .clk_xgmii_rx(clk_xgmii_rx),
    .reset_156m25_n(reset_156m25_n),
    .reset_xgmii_tx_n(reset_xgmii_tx_n),
    .reset_xgmii_rx_n(reset_xgmii_rx_n),
    .xgmii_rxd(xgmii_rxd),
    .xgmii_rxc(xgmii_rxc),
    .pkt_tx_val(pkt_tx_val),
    .pkt_tx_sop(pkt_tx_sop),
    .pkt_tx_mod(pkt_tx_mod),
    .pkt_tx_eop(pkt_tx_eop),
    .pkt_tx_data(pkt_tx_data),
    .pkt_rx_ren(pkt_rx_ren),
    .pkt_rx_val(pkt_rx_val),
    .pkt_rx_sop(pkt_rx_sop),
    .pkt_rx_eop(pkt_rx_eop),
    .pkt_rx_mod(pkt_rx_mod),
    .pkt_rx_err(pkt_rx_err),
    .pkt_rx_data(pkt_rx_data),
    .pkt_rx_avail(pkt_rx_avail),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_cyc_i(wb_cyc_i),
    .wb_stb_i(wb_stb_i),
    .wb_we_i(wb_we_i),
    .wb_adr_i(wb_adr_i),
    .wb_dat_i(wb_dat_i),
    .wb_dat_o(wb_dat_o),
    .wb_ack_o(wb_ack_o),
    .wb_int_o(wb_int_o),
    .xgmii_txd(xgmii_txd),
    .xgmii_txc(xgmii_txc),
    .pkt_tx_full(pkt_tx_full)
  );

  assign xgmii_rxd = xgmii_txd;
  assign xgmii_rxc = xgmii_txc;
  initial begin
    $display("Starting simulation...");
    // Apply reset
    reset_156m25_n = 0;
    reset_xgmii_tx_n = 0;
    reset_xgmii_rx_n = 0;
   // wb_rst_i = 1;
    #50;
    reset_156m25_n = 1;
    reset_xgmii_tx_n = 1;
    reset_xgmii_rx_n = 1;
    //wb_rst_i = 0;

    // Send a single packet
    @(posedge clk_156m25);
    pkt_tx_sop <= 1;
    pkt_tx_val <= 1;
    pkt_tx_data <= 64'hAABBCCDDEEFF0011;
    @(posedge clk_156m25);
    pkt_tx_sop <= 0;
    pkt_tx_data <= 64'h2233445566778899;
    @(posedge clk_156m25);
    pkt_tx_data <= 64'hDEADBEEFCAFEBABE;
    pkt_tx_eop <= 1;
    pkt_tx_mod <= 3'd1;
    @(posedge clk_156m25);
    pkt_tx_val <= 0;
    pkt_tx_eop <= 0;

    #500;
    $finish;
  end

endmodule
