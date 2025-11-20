// Exercises lane-specific patterns to hit per-lane coverage bins
class gpu_vector_lane_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_vector_lane_seq)

  bit [32*4-1:0] lane_patterns[$];

  function new(string name="gpu_vector_lane_seq");
    super.new(name);
    // Precompute patterns (little endian lane packing)
    lane_patterns.push_back({32'd1, 32'd0, 32'd0, 32'd0}); // lane0 hot
    lane_patterns.push_back({32'd0, 32'd1, 32'd0, 32'd0}); // lane1 hot
    lane_patterns.push_back({32'd0, 32'd0, 32'd1, 32'd0}); // lane2 hot
    lane_patterns.push_back({32'd0, 32'd0, 32'd0, 32'd1}); // lane3 hot
    lane_patterns.push_back({32'hFFFF_FFFF,32'h0000_0001,32'h8000_0000,32'h7FFF_FFFF});
    lane_patterns.push_back({32'd4,32'd3,32'd2,32'd1}); // descending
    lane_patterns.push_back({32'd1,32'd2,32'd3,32'd4}); // ascending
  endfunction

  task body();
    gpu_seq_item req;
    gpu_seq_item::opcode_e ops[$] = '{
      gpu_seq_item::OPC_ADD,
      gpu_seq_item::OPC_SUB,
      gpu_seq_item::OPC_MUL,
      gpu_seq_item::OPC_MAC
    };

    if (starting_phase != null)
      starting_phase.raise_objection(this);

    foreach (ops[idx]) begin
      foreach (lane_patterns[p_idx]) begin
        req = gpu_seq_item::type_id::create(
          $sformatf("vec_lane_op%0d_pat%0d", idx, p_idx),, get_full_name());
        start_item(req);
        req.is_vector = 1'b1;
        req.opcode    = ops[idx];
        req.a_v       = lane_patterns[p_idx];
        req.b_v       = lane_patterns[(p_idx+1)%lane_patterns.size()];
        req.c_v       = (ops[idx] == gpu_seq_item::OPC_MAC)
                        ? lane_patterns[(p_idx+2)%lane_patterns.size()]
                        : '0;
        req.a_s = '0;
        req.b_s = '0;
        req.c_s = '0;
        finish_item(req);
      end
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass: gpu_vector_lane_seq


