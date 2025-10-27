class ether_driver extends uvm_driver #(ether_seq_item); 
`uvm_component_utils(ether_driver) 

virtual ether_interface.drv_cb intf; 

function new(string name = "ether_driver", uvm_component parent); 
super.new(name, parent); 
endfunction 

function void build_phase(uvm_phase phase); 
super.build_phase(phase); 
if (!uvm_config_db#(virtual ether_interface.drv_cb)::get(this, "", "intf", intf)) 
 `uvm_fatal(get_full_name(), "Failed to get interface from config DB in driver"); 
endfunction 

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  @(posedge intf.clk);
  repeat (3) @(posedge intf.clk);

  forever begin
    ether_seq_item req;
    seq_item_port.get_next_item(req);

    `uvm_info(get_full_name(),
              $sformatf("Sending frame of %0d bytes (%0d beats)",
                        req.payload.size(), req.pkt_tx_data.size()), UVM_LOW)

    // Drive all 64-bit words
    foreach (req.pkt_tx_data[i]) begin
      // Wait until TX FIFO is not full
      @(posedge intf.clk);
      wait (!intf.pkt_tx_full);

      // Drive via clocking block
      intf.drv_cb.pkt_tx_data <= req.pkt_tx_data[i];
      intf.drv_cb.pkt_tx_val  <= 1;
      intf.drv_cb.pkt_tx_sop  <= (i == 0);
      intf.drv_cb.pkt_tx_eop  <= (i == req.pkt_tx_data.size() - 1);
      intf.drv_cb.pkt_tx_mod  <= (i == req.pkt_tx_data.size() - 1) ? (req.payload.size() % 8) : 0;

      `uvm_info("DRIVER", $sformatf("TXD[%0d] = %0h", i, req.pkt_tx_data[i]), UVM_MEDIUM)
    end

    // Deassert after last beat
    @(posedge intf.clk);
    intf.drv_cb.pkt_tx_val <= 0;
    intf.drv_cb.pkt_tx_sop <= 0;
    intf.drv_cb.pkt_tx_eop <= 0;
    intf.drv_cb.pkt_tx_mod <= 0;
    intf.drv_cb.pkt_rx_ren <= 1;
    seq_item_port.item_done();
  end
endtask
endclass
