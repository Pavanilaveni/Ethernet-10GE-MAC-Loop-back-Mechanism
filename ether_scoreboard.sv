class eth_scbd extends uvm_scoreboard;

`uvm_component_utils(eth_scbd)

`uvm_analysis_imp_decl(_port1)
`uvm_analysis_imp_decl(_port2)

ether_seq_item tx_q[$];
ether_seq_item rx_q[$];

uvm_analysis_imp_port1#(ether_seq_item,eth_scbd) imp_port1;
uvm_analysis_imp_port2#(ether_seq_item,eth_scbd) imp_port2;

ether_seq_item ref_data, dut_data;
virtual ether_interface intf;

function new(string name, uvm_component parent);
    super.new(name,parent);
    imp_port1 = new("imp_port1",this);
    imp_port2 = new("imp_port2",this);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ref_data=ether_seq_item::type_id::create("ref_data",this);
    dut_data=ether_seq_item::type_id::create("dut_data",this);
    if(!uvm_config_db#(virtual ether_interface)::get(this,"","intf",intf))
        `uvm_error("eth_scbd","config failed")
endfunction

function void write_port1(ether_seq_item tx_data);
    tx_q.push_back(tx_data);
endfunction

function void write_port2(ether_seq_item rx_data);
    rx_q.push_back(rx_data);
//endfunction

//task run_phase (uvm_phase phase);
  //  super.run_phase(phase);
    
    for(int i=0; i < rx_data.pkt_rx_data.size(); i++) begin
                if(tx_q.size() > 0 && rx_q.size() > 0) begin
                    ref_data = tx_q.pop_front();
                    dut_data = rx_q.pop_front();
                    
                    if(ref_data.pkt_tx_data.size() == 0)begin
                        `uvm_error(get_name(),"tx data is empty")
                    end
                end

    if(ref_data.pkt_tx_data[i] == dut_data.pkt_rx_data[i])
        `uvm_info(get_full_name(),"------------ Yeeea test passed ------------",UVM_NONE)
    else
        `uvm_error(get_full_name(),"----------- :C Try again -----------")
    end

endfunction



endclass

