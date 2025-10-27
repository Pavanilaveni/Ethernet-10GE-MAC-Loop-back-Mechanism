`include "xge_mac.v"
`include "timescale.v"
module testbench;
    
reg                   clk=0;
reg                   clk_156m25;
reg                   clk_xgmii_rx;
reg                   clk_xgmii_tx;
reg                   pkt_rx_ren;
reg [63:0]            pkt_tx_data;
reg                   pkt_tx_eop;
reg [2:0]             pkt_tx_mod;
reg                   pkt_tx_sop;
reg                   pkt_tx_val;
reg                   reset_156m25_n=0;
reg                   reset_xgmii_rx_n=0;
reg                   reset_xgmii_tx_n=0;

reg [7:0]             wb_adr_i;
reg                   wb_clk_i=0;
reg                   wb_cyc_i;
reg [31:0]            wb_dat_i=0;
reg                   wb_rst_i=1;
reg                   wb_stb_i;
reg                   wb_we_i;
wire                  wb_ack_o;
wire [31:0]           wb_dat_o;
wire                  wb_int_o;

wire [7:0]             xgmii_rxc;
wire [63:0]            xgmii_rxd; 

wire                  pkt_rx_avail;
wire [63:0]           pkt_rx_data;
wire                  pkt_rx_eop;
wire                  pkt_rx_err;
wire [2:0]            pkt_rx_mod;
wire                  pkt_rx_sop;
wire                  pkt_rx_val;
wire                  pkt_tx_full;
wire [7:0]            xgmii_txc;
wire [63:0]           xgmii_txd;

//loop counters and variables
integer i,pkt_idx;
integer word_i;

//Packet storage: 3 packets, each with 3 words (64 bits each)
reg [63:0] tx_packets [0:2][0:2];

xge_mac dut(.xgmii_txd(xgmii_txd),
            .xgmii_txc(xgmii_txc),
            .wb_int_o(wb_int_o),
            .wb_dat_o(wb_dat_o),
            .wb_ack_o(wb_ack_o),
            .pkt_tx_full(pkt_tx_full),
            .pkt_rx_val(pkt_rx_val),
            .pkt_rx_sop(pkt_rx_sop),
            .pkt_rx_mod(pkt_rx_mod),
            .pkt_rx_err(pkt_rx_err),
            .pkt_rx_eop(pkt_rx_eop),
            .pkt_rx_data(pkt_rx_data),
            .pkt_rx_avail(pkt_rx_avail),
            .xgmii_rxd(xgmii_rxd),
            .xgmii_rxc(xgmii_rxc),
            .wb_we_i(wb_we_i),
            .wb_stb_i(wb_stb_i),
            .wb_rst_i(wb_rst_i),
            .wb_dat_i(wb_dat_i),
            .wb_cyc_i(wb_cyc_i),
            .wb_clk_i(wb_clk_i),
            .wb_adr_i(wb_adr_i),
            .reset_xgmii_tx_n(reset_xgmii_tx_n),
            .reset_xgmii_rx_n(reset_xgmii_rx_n),
            .reset_156m25_n(reset_156m25_n),
            .pkt_tx_val(pkt_tx_val), 
            .pkt_tx_sop(pkt_tx_sop), 
            .pkt_tx_mod(pkt_tx_mod), 
            .pkt_tx_eop(pkt_tx_eop),
            .pkt_tx_data(pkt_tx_data),
            .pkt_rx_ren(pkt_rx_ren),
            .clk_xgmii_tx(clk),
            .clk_xgmii_rx(clk),
            .clk_156m25(clk));
 
    always #3.2 clk = ~clk; //156.25 MHz = 6.4ns period
    always #4 wb_clk_i = ~wb_clk_i; //wishbone clk 125MHz
    
    assign xgmii_rxd = xgmii_txd;
    assign xgmii_rxc = xgmii_txc;

    task send_packet(input integer pkt_i);
        begin
            for(word_i = 0; word_i < 3; word_i = word_i+1) begin
                    @(posedge clk);
                    pkt_tx_val <= 1'b1;
                    pkt_tx_sop <= (word_i == 0);
                    pkt_tx_eop <= (word_i == 2);
                    pkt_tx_mod <= 3'b00;
                    pkt_tx_data <= tx_packets[pkt_i][word_i];
                    @(posedge clk);
                    pkt_tx_sop <= 1'b0;
                    pkt_tx_eop <= 1'b0;
                end
                @(posedge clk);
                pkt_tx_val <= 1'b0;
        end
    endtask

    initial begin
        $display("Starting Simulation........ ");

        // Initialize packets
        tx_packets[0][0] = 64'h1122334455667788;
        tx_packets[0][1] = 64'h2233445566778899;
        tx_packets[0][2] = 64'h33445566778899aa;

        tx_packets[1][0] = 64'h445566778899aabb;
        tx_packets[1][1] = 64'h5566778899aabbcc;
        tx_packets[1][2] = 64'h66778899aabbccdd;
        
        tx_packets[2][0] = 64'h778899aabbccddee;
        tx_packets[2][1] = 64'h8899aabbccddeeff;
        tx_packets[2][2] = 64'h0123456789abcdef;
        
        //initailize signals
        pkt_tx_val =0;
        pkt_tx_sop =0;
        pkt_tx_eop =0;
        pkt_tx_mod =0;
        pkt_tx_data =0;
        pkt_rx_ren =0;

        //apply reset
        #50;
        reset_156m25_n = 1;
        reset_xgmii_rx_n = 1;
        reset_xgmii_tx_n = 1;
        wb_rst_i = 0;
        #100;

        //send packets with delay
        for(pkt_idx = 0; pkt_idx < 3; pkt_idx = pkt_idx+1) begin
                $display("Sending packets %0d",pkt_idx);
                send_packet(pkt_idx);
                #200; //delay between packets
            end

        //wait for RX
        #5000;
        $display("Simualtion finished");
        $finish;
   end

    always @(posedge clk or negedge reset_156m25_n) begin
        if(!reset_156m25_n) begin
             pkt_rx_ren <= 0;
        end
        else if (pkt_rx_avail) begin
             pkt_rx_ren <= 1;
             if(pkt_rx_val && pkt_rx_eop)
                pkt_rx_ren <=0;
        end
        else begin
             pkt_rx_ren <= 0;
        end
    end

    initial begin
        forever begin
            @(posedge clk);
            if(pkt_rx_val && pkt_rx_ren) begin
                $write("RX : %016h",pkt_rx_data);
                if(pkt_rx_sop) $write("[SOP]");
                if(pkt_rx_eop) $write("[EOP]");
                $display;
            end
        end
    end
/*
initial begin
    reset_xgmii_tx_n = reset_156m25_n;
    reset_xgmii_rx_n = reset_156m25_n;
    clk_xgmii_tx = clk_156m25;
    clk_xgmii_rx = clk_156m25;
  end
  // Reset sequence
  initial begin
    reset_156m25_n = 0;
    pkt_tx_val = 0;
    pkt_tx_sop = 0;
    pkt_tx_eop = 0;
    pkt_tx_mod = 0;
    pkt_tx_data = 0;
    pkt_rx_ren = 0;

    #50;
    reset_156m25_n = 1;
  end

  // TX stimulus
  initial begin
    wait(reset_156m25_n == 1);
    @(posedge clk_156m25);

    // Send a single 2-beat packet
    @(posedge clk_156m25);
    pkt_tx_val <= 1;
    pkt_tx_sop <= 1;
    pkt_tx_eop <= 0;
    pkt_tx_data <= 64'hAABBCCDDEEFF0011;
    pkt_tx_mod <= 0;

    @(posedge clk_156m25);
    pkt_tx_val <= 1;
    pkt_tx_sop <= 0;
    pkt_tx_eop <= 0;
    pkt_tx_data <= 64'hAABBCCDDEEFF11;
    pkt_tx_mod <= 0;

    @(posedge clk_156m25);
    pkt_tx_val <= 1;
    pkt_tx_sop <= 0;
    pkt_tx_eop <= 1;
    pkt_tx_data <= 64'h1122334455667788;
    pkt_tx_mod <= 7; // Example: last word has 5 valid bytes (8-3)

    @(posedge clk_156m25);
    pkt_tx_val <= 0;
    pkt_tx_sop <= 0;
    pkt_tx_eop <= 0;
    pkt_tx_data <= 0;
    pkt_tx_mod <= 0;
  end

  // RX capture
  initial begin
    wait(reset_156m25_n == 1);
    @(posedge clk_156m25);

    // Wait until RX data available
    wait(pkt_rx_avail == 1);

    // Start reading
    @(posedge clk_156m25);
    pkt_rx_ren <= 1;

    // Continue reading until pkt_rx_eop
    while (1) begin
      @(posedge clk_156m25);
      if (pkt_rx_val) begin
        $display("Time %0t: RX Data = %h, SOP=%b, EOP=%b, MOD=%0d, ERR=%b",
          $time, pkt_rx_data, pkt_rx_sop, pkt_rx_eop, pkt_rx_mod, pkt_rx_err);
      end
    end

    pkt_rx_ren <= 0;
    #50;
    $finish;
  end
*/

endmodule
