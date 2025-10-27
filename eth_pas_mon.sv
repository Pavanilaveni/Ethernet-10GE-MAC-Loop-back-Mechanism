class ether_passive_monitor extends uvm_monitor;
  `uvm_component_utils(ether_passive_monitor)

  ether_seq_item req;
  virtual ether_interface intf;

  uvm_analysis_port#(ether_seq_item) port2;

  function new(string name = "ether_passive_monitor", uvm_component parent);
    super.new(name, parent);
    port2=new("port2",this);
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
req.pkt_rx_data.delete;
end
        if (!intf.mon_cb.pkt_rx_err && intf.mon_cb.pkt_rx_ren) begin
          req.pkt_rx_data.push_back(intf.mon_cb.pkt_rx_data);
          req.pkt_rx_mod   <= intf.mon_cb.pkt_rx_mod;
          req.pkt_rx_sop   <= intf.mon_cb.pkt_rx_sop;
          req.pkt_rx_eop   <= intf.mon_cb.pkt_rx_eop;
          req.pkt_rx_val   <= intf.mon_cb.pkt_rx_val;
          req.pkt_rx_avail <= intf.mon_cb.pkt_rx_avail;
          `uvm_info(get_full_name(),$sformatf("pkt_rx_data=%0p , pkt_rx_avail=%0b",req.pkt_rx_data,intf.mon_cb.pkt_rx_avail),UVM_LOW)
        end
      end
      port2.write(req);
  endtask
endclass

