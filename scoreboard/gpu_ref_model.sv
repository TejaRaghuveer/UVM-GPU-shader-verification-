// Golden reference model for GPU shader operations
class gpu_ref_model;
  // Mirror common parameters from sequence item
  localparam int WIDTH = 32;
  localparam int LANES = 4;
  localparam int VEC_W = WIDTH*LANES;

  static function automatic bit [WIDTH-1:0] compute_scalar(
    gpu_seq_item::opcode_e opcode,
    bit [WIDTH-1:0] a,
    bit [WIDTH-1:0] b,
    bit [WIDTH-1:0] c
  );
    case (opcode)
      gpu_seq_item::OPC_ADD: compute_scalar = a + b;
      gpu_seq_item::OPC_SUB: compute_scalar = a - b;
      gpu_seq_item::OPC_MUL: compute_scalar = a * b;
      gpu_seq_item::OPC_MAC: compute_scalar = (a * b) + c;
      default:               compute_scalar = '0;
    endcase
  endfunction

  static function automatic bit [VEC_W-1:0] compute_vector(
    gpu_seq_item::opcode_e opcode,
    bit [VEC_W-1:0] a_v,
    bit [VEC_W-1:0] b_v,
    bit [VEC_W-1:0] c_v
  );
    bit [VEC_W-1:0] res;
    for (int i = 0; i < LANES; i++) begin
      bit [WIDTH-1:0] a = a_v[i*WIDTH +: WIDTH];
      bit [WIDTH-1:0] b = b_v[i*WIDTH +: WIDTH];
      bit [WIDTH-1:0] c = c_v[i*WIDTH +: WIDTH];
      res[i*WIDTH +: WIDTH] = compute_scalar(opcode, a, b, c);
    end
    return res;
  endfunction

  static function automatic void compute_expected(
    input  gpu_seq_item t,
    output bit [WIDTH-1:0] exp_s,
    output bit [VEC_W-1:0] exp_v
  );
    if (t.is_vector) begin
      exp_s = '0;
      exp_v = compute_vector(t.opcode, t.a_v, t.b_v, t.c_v);
    end else begin
      exp_s = compute_scalar(t.opcode, t.a_s, t.b_s, t.c_s);
      exp_v = '0;
    end
  endfunction
endclass: gpu_ref_model


