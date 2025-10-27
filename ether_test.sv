class ether_test extends uvm_test;
`uvm_component_utils(ether_test)

ether_env env;
ether_seq seq;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ether_env::type_id::create("env",this);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    seq = ether_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.A_agnt.seqr);
    `uvm_info(get_full_name(),"seq is connected to seqr in run phase",UVM_LOW)
    #5000;
    phase.drop_objection(this);
`uvm_info(get_full_name(),"drop objection is completed",UVM_NONE)
endtask

endclass

