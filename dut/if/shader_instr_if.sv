interface shader_instr_if #(parameter int OPCODE_W = 4) (input logic clk, input logic rst_n);
  logic                 valid;
  logic                 ready;
  logic [OPCODE_W-1:0] opcode;      // 0:ADD 1:SUB 2:MUL 3:MAC
  logic                 is_vector;  // 0: scalar, 1: vector

  // Producer drives request
  modport prod (
    input  clk, rst_n,
    output valid, opcode, is_vector,
    input  ready
  );

  // Consumer (core) receives request
  modport cons (
    input  clk, rst_n,
    input  valid, opcode, is_vector,
    output ready
  );
endinterface: shader_instr_if


