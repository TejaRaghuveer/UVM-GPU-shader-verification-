// Randomized stress sequence with weighted opcode distribution and random scalar/vector selection
class gpu_random_stress_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_random_stress_seq)

  rand int unsigned num_transactions;
  constraint num_transactions_c { num_transactions inside {[100:500]}; }

  function new(string name="gpu_random_stress_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item req;
    if (starting_phase != null) starting_phase.raise_objection(this);

    repeat (num_transactions) begin
      req = gpu_seq_item::type_id::create("req",, get_full_name());
      start_item(req);
      if (!req.randomize() with {
            opcode dist {
              gpu_seq_item::OPC_ADD := 4,
              gpu_seq_item::OPC_SUB := 4,
              gpu_seq_item::OPC_MUL := 3,
              gpu_seq_item::OPC_MAC := 3
            };
            is_vector dist { 1'b0 := 1, 1'b1 := 1 };
          }) begin
        `uvm_error(get_full_name(), "randomization failed in gpu_random_stress_seq")
      end
      finish_item(req);
    end

    if (starting_phase != null) starting_phase.drop_objection(this);
  endtask
endclass: gpu_random_stress_seq


