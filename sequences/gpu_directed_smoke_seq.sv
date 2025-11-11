// Directed smoke sequence: simple deterministic ops for bring-up
class gpu_directed_smoke_seq extends uvm_sequence#(gpu_seq_item);
  `uvm_object_utils(gpu_directed_smoke_seq)

  function new(string name="gpu_directed_smoke_seq");
    super.new(name);
  endfunction

  task body();
    gpu_seq_item t;
    if (starting_phase != null) starting_phase.raise_objection(this);

    // 1) Scalar ADD: 1 + 2 = 3
    t = gpu_seq_item::type_id::create("scalar_add");
    start_item(t);
    t.is_vector = 1'b0; t.opcode = gpu_seq_item::OPC_ADD;
    t.a_s = 32'd1; t.b_s = 32'd2; t.c_s = '0;
    t.a_v = '0; t.b_v = '0; t.c_v = '0;
    finish_item(t);

    // 2) Scalar SUB: 10 - 4 = 6
    t = gpu_seq_item::type_id::create("scalar_sub");
    start_item(t);
    t.is_vector = 1'b0; t.opcode = gpu_seq_item::OPC_SUB;
    t.a_s = 32'd10; t.b_s = 32'd4; t.c_s = '0;
    t.a_v = '0; t.b_v = '0; t.c_v = '0;
    finish_item(t);

    // 3) Scalar MUL: 7 * 8
    t = gpu_seq_item::type_id::create("scalar_mul");
    start_item(t);
    t.is_vector = 1'b0; t.opcode = gpu_seq_item::OPC_MUL;
    t.a_s = 32'd7; t.b_s = 32'd8; t.c_s = '0;
    t.a_v = '0; t.b_v = '0; t.c_v = '0;
    finish_item(t);

    // 4) Scalar MAC: 3*5 + 2
    t = gpu_seq_item::type_id::create("scalar_mac");
    start_item(t);
    t.is_vector = 1'b0; t.opcode = gpu_seq_item::OPC_MAC;
    t.a_s = 32'd3; t.b_s = 32'd5; t.c_s = 32'd2;
    t.a_v = '0; t.b_v = '0; t.c_v = '0;
    finish_item(t);

    // 5) Vector ADD across 4 lanes
    t = gpu_seq_item::type_id::create("vector_add");
    start_item(t);
    t.is_vector = 1'b1; t.opcode = gpu_seq_item::OPC_ADD;
    foreach (t.a_v[i]) begin end // avoid lints
    t.a_v = {32'd4, 32'd3, 32'd2, 32'd1};
    t.b_v = {32'd1, 32'd2, 32'd3, 32'd4};
    t.c_v = '0;
    t.a_s = '0; t.b_s = '0; t.c_s = '0;
    finish_item(t);

    if (starting_phase != null) starting_phase.drop_objection(this);
  endtask
endclass: gpu_directed_smoke_seq


