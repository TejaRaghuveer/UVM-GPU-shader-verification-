// Mixed sequence to cover scalar and vector operations for each opcode
class gpu_mixed_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_mixed_seq)

  int unsigned repetitions = 2; // repeat coverage pattern

  function new(string name="gpu_mixed_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item req;
    gpu_seq_item::opcode_e op_list[$] = '{
      gpu_seq_item::OPC_ADD,
      gpu_seq_item::OPC_SUB,
      gpu_seq_item::OPC_MUL,
      gpu_seq_item::OPC_MAC
    };

    if (starting_phase != null)
      starting_phase.raise_objection(this);

    repeat (repetitions) begin
      foreach (op_list[idx]) begin
        // Scalar instance
        req = gpu_seq_item::type_id::create($sformatf("req_scalar_%0d", idx),, get_full_name());
        start_item(req);
        if (!req.randomize() with { opcode == op_list[idx]; is_vector == 1'b0; }) begin
          `uvm_error(get_full_name(), "Mixed sequence scalar randomization failed")
        end
        finish_item(req);

        // Vector instance
        req = gpu_seq_item::type_id::create($sformatf("req_vector_%0d", idx),, get_full_name());
        start_item(req);
        if (!req.randomize() with { opcode == op_list[idx]; is_vector == 1'b1; }) begin
          `uvm_error(get_full_name(), "Mixed sequence vector randomization failed")
        end
        finish_item(req);
      end
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass: gpu_mixed_seq


