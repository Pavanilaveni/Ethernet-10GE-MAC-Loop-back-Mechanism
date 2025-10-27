class ether_passive_agent extends uvm_agent;

`uvm_component_utils(ether_passive_agent)

ether_passive_monitor mon2;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon2 = ether_passive_monitor::type_id::create("mon2",this);

endfunction

endclass
