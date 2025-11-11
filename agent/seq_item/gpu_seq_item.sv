// Sequence item for GPU shader operations
class gpu_seq_item extends uvm_sequence_item;
  `uvm_object_utils(gpu_seq_item)

  // Parameters mirrored from DUT interfaces
  localparam int WIDTH  = 32;
  localparam int LANES  = 4;
  localparam int VEC_W  = WIDTH*LANES;
  localparam int OPCODE_W = 4;

  typedef enum bit [OPCODE_W-1:0] {
    OPC_ADD = 'h0,
    OPC_SUB = 'h1,
    OPC_MUL = 'h2,
    OPC_MAC = 'h3
  } opcode_e;

  // Instruction fields
  rand opcode_e           opcode;
  rand bit                is_vector;  // 0: scalar, 1: vector

  // Scalar operands
  rand bit [WIDTH-1:0]    a_s;
  rand bit [WIDTH-1:0]    b_s;
  rand bit [WIDTH-1:0]    c_s;

  // Vector operands (packed)
  rand bit [VEC_W-1:0]    a_v;
  rand bit [VEC_W-1:0]    b_v;
  rand bit [VEC_W-1:0]    c_v;

  // Observed results (filled by monitor/scoreboard)
  bit [WIDTH-1:0]         result_s;
  bit [VEC_W-1:0]         result_v;

  // Simple constraint: when scalar, zero out vector fields; when vector, zero scalar fields
  constraint scalar_vector_consistency {
    if (is_vector == 1'b0) {
      a_v == '0; b_v == '0; c_v == '0;
    } else {
      a_s == '0; b_s == '0; c_s == '0;
    }
  }

  function new(string name="gpu_seq_item");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(gpu_seq_item)
    `uvm_field_enum(opcode_e, opcode, UVM_ALL_ON)
    `uvm_field_int(is_vector, UVM_ALL_ON)
    `uvm_field_int(a_s, UVM_ALL_ON)
    `uvm_field_int(b_s, UVM_ALL_ON)
    `uvm_field_int(c_s, UVM_ALL_ON)
    `uvm_field_int(a_v, UVM_ALL_ON)
    `uvm_field_int(b_v, UVM_ALL_ON)
    `uvm_field_int(c_v, UVM_ALL_ON)
    `uvm_field_int(result_s, UVM_DEC)
    `uvm_field_int(result_v, UVM_DEC)
  `uvm_object_utils_end
endclass: gpu_seq_item

