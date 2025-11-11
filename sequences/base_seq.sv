// Base sequence for GPU Shader
class gpu_base_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_base_seq)

  rand int unsigned num_transactions;
  constraint num_transactions_c { num_transactions inside {[5:20]}; }

  function new(string name="gpu_base_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item req;
    if (starting_phase != null)
      starting_phase.raise_objection(this);

    repeat (num_transactions) begin
      req = gpu_seq_item::type_id::create("req");
      start_item(req);
      if (!req.randomize() with {
            opcode dist {
              gpu_seq_item::OPC_ADD := 3,
              gpu_seq_item::OPC_SUB := 3,
              gpu_seq_item::OPC_MUL := 2,
              gpu_seq_item::OPC_MAC := 2
            };
            is_vector dist { 1'b0 := 1, 1'b1 := 1 };
          }) begin
        `uvm_error(get_full_name(), "Failed to randomize gpu_seq_item in gpu_base_seq")
      end
      finish_item(req);
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass: gpu_base_seq


