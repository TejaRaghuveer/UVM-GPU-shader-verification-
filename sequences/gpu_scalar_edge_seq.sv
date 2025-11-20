// Directed scalar edge-case sweep to cover zero/max/small/negative bins
class gpu_scalar_edge_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_scalar_edge_seq)

  bit [31:0] edge_vals[$] = '{
    32'h0000_0000, // zero
    32'h0000_0001, // small
    32'hFFFF_FFFF, // -1
    32'h8000_0000, // min signed
    32'h7FFF_FFFF  // max signed
  };

  function new(string name="gpu_scalar_edge_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item::opcode_e ops[$] = '{
      gpu_seq_item::OPC_ADD,
      gpu_seq_item::OPC_SUB,
      gpu_seq_item::OPC_MUL,
      gpu_seq_item::OPC_MAC
    };

    if (starting_phase != null)
      starting_phase.raise_objection(this);

    foreach (ops[idx]) begin
      foreach (edge_vals[a_idx]) begin
        foreach (edge_vals[b_idx]) begin
          gpu_seq_item req = gpu_seq_item::type_id::create(
            $sformatf("scalar_edge_%0d_%0d_%0d", idx, a_idx, b_idx),, get_full_name());
          start_item(req);
          req.is_vector = 1'b0;
          req.opcode    = ops[idx];
          req.a_s       = edge_vals[a_idx];
          req.b_s       = edge_vals[b_idx];
          req.c_s       = (ops[idx] == gpu_seq_item::OPC_MAC)
                          ? edge_vals[$urandom_range(0, edge_vals.size()-1)]
                          : '0;
          req.a_v = '0;
          req.b_v = '0;
          req.c_v = '0;
          finish_item(req);
        end
      end
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass: gpu_scalar_edge_seq


