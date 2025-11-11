interface shader_data_if #(
  parameter int WIDTH = 32,
  parameter int LANES = 4
) (input logic clk, input logic rst_n);
  localparam int VEC_W = WIDTH*LANES;

  logic              valid;
  logic              ready;
  // Scalar operands
  logic [WIDTH-1:0]  a_s;
  logic [WIDTH-1:0]  b_s;
  logic [WIDTH-1:0]  c_s;           // used for MAC
  // Vector operands (packed)
  logic [VEC_W-1:0]  a_v;
  logic [VEC_W-1:0]  b_v;
  logic [VEC_W-1:0]  c_v;           // used for MAC

  modport prod (
    input  clk, rst_n,
    output valid, a_s, b_s, c_s, a_v, b_v, c_v,
    input  ready
  );

  modport cons (
    input  clk, rst_n,
    input  valid, a_s, b_s, c_s, a_v, b_v, c_v,
    output ready
  );
endinterface: shader_data_if


