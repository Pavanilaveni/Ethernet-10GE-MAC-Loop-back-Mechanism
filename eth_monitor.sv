class ether_active_monitor extends uvm_monitor;
  `uvm_component_utils(ether_active_monitor)

  ether_seq_item req;
  virtual ether_interface intf;

  uvm_analysis_port#(ether_seq_item) port1;

  function new(string name = "ether_active_monitor", uvm_component parent);
    super.new(name, parent);
    port1=new("port1",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ether_interface)::get(this,"","intf",intf)) begin
      `uvm_fatal(get_type_name(),"Failed to get interface in active_monitor")
    end
    else begin
      `uvm_info(get_type_name(),"Config DB in active_monitor done",UVM_NONE)
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    req = ether_seq_item::type_id::create("req",this);
    forever begin
      @(posedge intf.mon_cb);
      req.pkt_rx_data = {};

      if (intf.rst==0) begin
req.pkt_tx_data.delete;
end
if(intf.mon_cb.pkt_tx_val && intf.mon_cb.pkt_tx_sop) begin

       req.pkt_tx_data.push_back(intf.mon_cb.pkt_tx_data);
        req.pkt_tx_mod  <= intf.mon_cb.pkt_tx_mod;
        req.pkt_tx_val   <= intf.mon_cb.pkt_tx_val;
        req.pkt_tx_sop   <= intf.mon_cb.pkt_tx_sop;
        req.pkt_tx_eop   <= intf.mon_cb.pkt_tx_eop;
        req.pkt_tx_full  <= intf.mon_cb.pkt_tx_full;

        `uvm_info(get_full_name(),$sformatf("pkt_tx_data = %0h", intf.mon_cb.pkt_tx_data), UVM_LOW)
      end
      port1.write(req);
      end
  endtask
endclass

