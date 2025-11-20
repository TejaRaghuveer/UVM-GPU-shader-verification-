// MAC-focused stress with bias toward wide operands and non-zero c
class gpu_mac_stress_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_mac_stress_seq)

  rand int unsigned num_transactions;
  constraint num_transactions_c { num_transactions inside {[80:200]}; }

  function new(string name="gpu_mac_stress_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item req;
    if (starting_phase != null)
      starting_phase.raise_objection(this);

    repeat (num_transactions) begin
      req = gpu_seq_item::type_id::create("mac_req",, get_full_name());
      start_item(req);
      if (!req.randomize() with {
            opcode == gpu_seq_item::OPC_MAC;
            is_vector dist {1'b0 := 1, 1'b1 := 2};
            // Bias operands toward high magnitude and varied signs
            (is_vector == 0) -> {
              a_s dist {['hFFFF0000:'hFFFF_FFFF] := 2, ['h0000_0000:'h0000_FFFF] := 1};
              b_s dist {['hFFFF0000:'hFFFF_FFFF] := 2, ['h0000_0000:'h0000_FFFF] := 1};
              c_s dist {['hFFFF0000:'hFFFF_FFFF] := 1, ['h0000_0000:'h0000_FFFF] := 1};
            };
          }) begin
        `uvm_error(get_full_name(), "Randomize failed in gpu_mac_stress_seq")
      end
      finish_item(req);
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass: gpu_mac_stress_seq


