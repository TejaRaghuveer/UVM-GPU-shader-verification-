// Handshake-stress sequence: pushes back-to-back requests with optional gaps
class gpu_handshake_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_handshake_seq)

  rand int unsigned num_transactions;
  rand int unsigned burst_len;
  rand bit          prefer_vectors;

  constraint num_transactions_c { num_transactions inside {[40:120]}; }
  constraint burst_len_c        { burst_len inside {[1:6]}; }

  function new(string name="gpu_handshake_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item tr;
    gpu_agent_config cfg = null;
    virtual shader_instr_if instr_vif;

    if (p_sequencer != null)
      cfg = p_sequencer.get_cfg();
    if (cfg != null)
      instr_vif = cfg.instr_vif;

    if (starting_phase != null)
      starting_phase.raise_objection(this);

    for (int tx = 0; tx < num_transactions; tx++) begin
      tr = gpu_seq_item::type_id::create($sformatf("hs_tr_%0d", tx),, get_full_name());
      start_item(tr);
      if (!tr.randomize() with {
            opcode dist {
              gpu_seq_item::OPC_ADD := 3,
              gpu_seq_item::OPC_SUB := 3,
              gpu_seq_item::OPC_MUL := 2,
              gpu_seq_item::OPC_MAC := 2
            };
            is_vector dist {
              1'b0 := prefer_vectors ? 1 : 3,
              1'b1 := prefer_vectors ? 3 : 1
            };
          }) begin
        `uvm_error(get_full_name(), "Randomization failed in gpu_handshake_seq")
      end
      finish_item(tr);

      // Randomly insert short idle gaps to mix single-cycle and back-to-back traffic
      int gap_cycles = $urandom_range(0,2);
      if (instr_vif != null && gap_cycles > 0) begin
        repeat (gap_cycles) @(posedge instr_vif.clk);
      end
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass: gpu_handshake_seq


