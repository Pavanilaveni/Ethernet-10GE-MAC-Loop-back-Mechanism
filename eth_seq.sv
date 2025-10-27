class ether_seq extends uvm_sequence#(ether_seq_item);

  `uvm_object_utils(ether_seq)

  ether_seq_item req;

  function new(string name="ether_seq");
    super.new(name);
  endfunction

task body();

  bit [63:0] temp_payload;
  bit [63:0] word;
  int frame_data;
  int i;

  repeat(3) begin
    req = ether_seq_item::type_id::create("req");
    start_item(req);

    if(!req.randomize()) begin
      `uvm_error("ETHER SEQUENCE","Randomization failed for seq_item")
    end

    // Ethernet header fields
    req.preamble = 56'h5555_5555_5555_55;
    req.sfd      = 8'hD5;
    
    // Random payload size
    frame_data = $urandom_range(46,100);
       req.ether_type = 16'h0800;

    // Use a known MAC for consistency
   req.mac_dst_addr = 48'hFF_FF_FF_FF_FF_FF; // broadcast
    req.mac_src_addr = 48'h00_11_22_33_44_55;

    req.payload = new[frame_data];
    for(i=0;i<frame_data;i++) begin
      req.payload[i] = $urandom_range(0,255);
    end

    // Build pkt_tx_data
    req.pkt_tx_data = {};
    req.pkt_tx_data.push_back({req.preamble, req.sfd});
    word = {req.mac_dst_addr, req.mac_src_addr[47:32]};
    req.pkt_tx_data.push_back(word);
    word = {req.mac_src_addr[31:0], req.ether_type, 16'h0000};
    req.pkt_tx_data.push_back(word);

    for(i=0;i<req.payload.size();i+=8) begin
      temp_payload = 64'd0;
      if(i+0 < req.payload.size()) temp_payload[7:0]   = req.payload[i+0]; 
      if(i+1 < req.payload.size()) temp_payload[15:8]  = req.payload[i+1];
      if(i+2 < req.payload.size()) temp_payload[23:16] = req.payload[i+2];
      if(i+3 < req.payload.size()) temp_payload[31:24] = req.payload[i+3];
      if(i+4 < req.payload.size()) temp_payload[39:32] = req.payload[i+4];
      if(i+5 < req.payload.size()) temp_payload[47:40] = req.payload[i+5];
      if(i+6 < req.payload.size()) temp_payload[55:48] = req.payload[i+6];
      if(i+7 < req.payload.size()) temp_payload[63:56] = req.payload[i+7];
      req.pkt_tx_data.push_back(temp_payload);
    end

    finish_item(req);
  end

endtask
    
endclass

