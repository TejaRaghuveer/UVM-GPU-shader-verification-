// Scalar-only sequence for GPU shader
class gpu_scalar_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_scalar_seq)

  rand int unsigned num_transactions;
  constraint num_transactions_c { num_transactions inside {[10:40]}; }

  function new(string name="gpu_scalar_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item req;
    if (starting_phase != null)
      starting_phase.raise_objection(this);

    repeat (num_transactions) begin
      req = gpu_seq_item::type_id::create("req",, get_full_name());
      start_item(req);
      if (!req.randomize() with {
            is_vector == 1'b0;
            opcode inside {gpu_seq_item::OPC_ADD,
                           gpu_seq_item::OPC_SUB,
                           gpu_seq_item::OPC_MUL,
                           gpu_seq_item::OPC_MAC};
          }) begin
        `uvm_error(get_full_name(), "Scalar sequence randomization failed")
      end
      finish_item(req);
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass: gpu_scalar_seq


