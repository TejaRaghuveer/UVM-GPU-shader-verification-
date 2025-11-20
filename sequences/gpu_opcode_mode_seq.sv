// Ensures every opcode is exercised in scalar and vector mode back-to-back
class gpu_opcode_mode_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_opcode_mode_seq)

  int unsigned repetitions = 2;

  function new(string name="gpu_opcode_mode_seq");
    super.new(name);
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

    repeat (repetitions) begin
      foreach (ops[idx]) begin
        // scalar then vector for each opcode
        foreach (bit mode in '{1'b0, 1'b1}) begin
          req = gpu_seq_item::type_id::create(
            $sformatf("op_%0d_mode_%0d", idx, mode),, get_full_name());
          start_item(req);
          if (!req.randomize() with {
                opcode == ops[idx];
                is_vector == mode;
              }) begin
            `uvm_error(get_full_name(), "Randomize failed in gpu_opcode_mode_seq")
          end
          finish_item(req);
        end
      end
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass: gpu_opcode_mode_seq


