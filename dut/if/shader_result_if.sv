interface shader_result_if #(
  parameter int WIDTH = 32,
  parameter int LANES = 4
) (input logic clk, input logic rst_n);
  localparam int VEC_W = WIDTH*LANES;

  logic              valid;
  logic              ready;
  logic [WIDTH-1:0]  result_s;
  logic [VEC_W-1:0]  result_v;

  modport prod (
    input  clk, rst_n,
    output valid, result_s, result_v,
    input  ready
  );

  modport cons (
    input  clk, rst_n,
    input  valid, result_s, result_v,
    output ready
  );
endinterface: shader_result_if


