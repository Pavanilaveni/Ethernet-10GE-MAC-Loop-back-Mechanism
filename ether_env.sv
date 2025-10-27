class ether_env extends uvm_env;

`uvm_component_utils(ether_env)
ether_active_agent A_agnt;
ether_passive_agent P_agnt;
eth_scbd scbd;
ether_subscriber subscr;

function new(string name = "ether_env", uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    A_agnt = ether_active_agent::type_id::create("A_agnt",this);
    P_agnt = ether_passive_agent::type_id::create("P_agnt",this);
    scbd = eth_scbd::type_id::create("scbd",this);
    subscr = ether_subscriber::type_id::create("subscr",this);
endfunction

function void connect_phase(uvm_phase phase);
    A_agnt.mon.port1.connect(scbd.imp_port1);
    P_agnt.mon2.port2.connect(scbd.imp_port2);
    A_agnt.mon.port1.connect(subscr.analysis_export);
endfunction



endclass

