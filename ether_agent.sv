class ether_active_agent extends uvm_agent;

`uvm_component_utils(ether_active_agent)
ether_driver drv;
ether_seqr seqr;
ether_active_monitor mon;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = ether_driver::type_id::create("drv",this);
    seqr = ether_seqr::type_id::create("seqr",this);
    mon = ether_active_monitor::type_id::create("mon",this);

endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    `uvm_info(get_full_name(),"driver connected to sequencer",UVM_NONE);
endfunction


endclass
