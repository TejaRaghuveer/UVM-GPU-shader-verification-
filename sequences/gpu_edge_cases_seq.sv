// Directed edge-case sequence: zeros, max values, negative patterns (2's complement), and mixed vectors
class gpu_edge_cases_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_edge_cases_seq)

  function new(string name="gpu_edge_cases_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item t;
    if (starting_phase != null) starting_phase.raise_objection(this);

    // Scalar zero operations
    foreach (int op_idx[4]) begin end // quiet lints
    gpu_seq_item::opcode_e ops[$] = '{gpu_seq_item::OPC_ADD, gpu_seq_item::OPC_SUB,
                                      gpu_seq_item::OPC_MUL, gpu_seq_item::OPC_MAC};
    foreach (ops[i]) begin
      t = gpu_seq_item::type_id::create($sformatf("scalar_zero_%0d", i));
      start_item(t);
      t.is_vector = 1'b0; t.opcode = ops[i];
      t.a_s = '0; t.b_s = '0; t.c_s = '0;
      t.a_v = '0; t.b_v = '0; t.c_v = '0;
      finish_item(t);
    end

    // Scalar max values
    foreach (ops[i]) begin
      t = gpu_seq_item::type_id::create($sformatf("scalar_max_%0d", i));
      start_item(t);
      t.is_vector = 1'b0; t.opcode = ops[i];
      t.a_s = '1; t.b_s = '1; t.c_s = '1;
      t.a_v = '0; t.b_v = '0; t.c_v = '0;
      finish_item(t);
    end

    // Scalar negative patterns (assuming WIDTH=32 two's complement)
    foreach (ops[i]) begin
      t = gpu_seq_item::type_id::create($sformatf("scalar_neg_%0d", i));
      start_item(t);
      t.is_vector = 1'b0; t.opcode = ops[i];
      t.a_s = 32'hFFFF_FFFF; // -1
      t.b_s = 32'h8000_0000; // min int
      t.c_s = 32'h0000_0001; // +1
      t.a_v = '0; t.b_v = '0; t.c_v = '0;
      finish_item(t);
    end

    // Vector mixed lanes (0, max, small, negative)
    t = gpu_seq_item::type_id::create("vector_mixed_add");
    start_item(t);
    t.is_vector = 1'b1; t.opcode = gpu_seq_item::OPC_ADD;
    t.a_v = {32'h0000_0000, 32'hFFFF_FFFF, 32'd3, 32'h8000_0000};
    t.b_v = {32'd1, 32'd1, 32'd4, 32'h7FFF_FFFF};
    t.c_v = '0;
    t.a_s='0; t.b_s='0; t.c_s='0;
    finish_item(t);

    // Vector MAC with varied c
    t = gpu_seq_item::type_id::create("vector_mixed_mac");
    start_item(t);
    t.is_vector = 1'b1; t.opcode = gpu_seq_item::OPC_MAC;
    t.a_v = {32'd2, 32'd3, 32'd4, 32'd5};
    t.b_v = {32'd6, 32'd7, 32'd8, 32'd9};
    t.c_v = {32'd1, 32'd2, 32'd3, 32'd4};
    t.a_s='0; t.b_s='0; t.c_s='0;
    finish_item(t);

    if (starting_phase != null) starting_phase.drop_objection(this);
  endtask
endclass: gpu_edge_cases_seq


