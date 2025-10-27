class ether_seqr extends uvm_sequencer #(ether_seq_item);

`uvm_component_utils(ether_seqr)

function new (string name="ether_seqr",uvm_component parent);
super.new(name,parent);
endfunction

endclass
