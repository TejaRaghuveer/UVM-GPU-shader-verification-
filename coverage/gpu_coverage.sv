// Coverage skeleton
class gpu_coverage extends uvm_subscriber#(gpu_seq_item);
  `uvm_component_utils(gpu_coverage)

  // Mirrors of parameters
  localparam int WIDTH = 32;
  localparam int LANES = 4;
  localparam int VEC_W = WIDTH*LANES;

  // Sampled copy
  gpu_seq_item tr;

  covergroup cg_shader_ops with function sample(gpu_seq_item t);
    // Opcode bins
    cp_opcode: coverpoint t.opcode {
      bins add = {gpu_seq_item::OPC_ADD};
      bins sub = {gpu_seq_item::OPC_SUB};
      bins mul = {gpu_seq_item::OPC_MUL};
      bins mac = {gpu_seq_item::OPC_MAC};
    }
    // Mode bins
    cp_mode: coverpoint t.is_vector {
      bins scalar = {1'b0};
      bins vector = {1'b1};
    }
    // Scalar operand edge cases
    cp_scalar_a: coverpoint t.a_s {
      bins zero = {'0};
      bins max  = {'1};
      bins small[] = {[0:15]};
    }
    cp_scalar_b: coverpoint t.b_s {
      bins zero = {'0};
      bins max  = {'1};
      bins small[] = {[0:15]};
    }
    // Cross coverage for opcode x mode
    x_opcode_mode: cross cp_opcode, cp_mode;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name,parent);
    cg_shader_ops = new();
  endfunction

  function void write(gpu_seq_item t);
    tr = t;
    cg_shader_ops.sample(t);
  endfunction
endclass: gpu_coverage
