module gpu_shader_core #(
  parameter int WIDTH = 32,
  parameter int LANES = 4,
  parameter int OPCODE_W = 4
) (
  input  logic clk,
  input  logic rst_n,
  shader_instr_if    #(OPCODE_W).cons instr_if,
  shader_data_if     #(WIDTH, LANES).cons data_if,
  shader_result_if   #(WIDTH, LANES).prod result_if
);
  localparam int VEC_W = WIDTH*LANES;

  typedef enum logic [OPCODE_W-1:0] {
    OPC_ADD = 'h0,
    OPC_SUB = 'h1,
    OPC_MUL = 'h2,
    OPC_MAC = 'h3
  } opcode_e;

  // Simple 1-entry pipeline
  logic                 pipe_valid_q, pipe_valid_d;
  logic [OPCODE_W-1:0]  opcode_q, opcode_d;
  logic                 is_vector_q, is_vector_d;
  logic [WIDTH-1:0]     a_s_q, b_s_q, c_s_q;
  logic [VEC_W-1:0]     a_v_q, b_v_q, c_v_q;

  // Handshake
  wire can_accept = ~pipe_valid_q;  // empty pipeline
  assign instr_if.ready = can_accept;
  assign data_if.ready  = can_accept;

  // Latch request when both sides valid and we can accept
  wire fire = can_accept & instr_if.valid & data_if.valid;

  always_comb begin
    pipe_valid_d = pipe_valid_q;
    opcode_d     = opcode_q;
    is_vector_d  = is_vector_q;
    a_s_q        = a_s_q; // default hold to avoid latches
    b_s_q        = b_s_q;
    c_s_q        = c_s_q;
    a_v_q        = a_v_q;
    b_v_q        = b_v_q;
    c_v_q        = c_v_q;

    if (fire) begin
      pipe_valid_d = 1'b1;
      opcode_d     = instr_if.opcode;
      is_vector_d  = instr_if.is_vector;
      a_s_q        = data_if.a_s;
      b_s_q        = data_if.b_s;
      c_s_q        = data_if.c_s;
      a_v_q        = data_if.a_v;
      b_v_q        = data_if.b_v;
      c_v_q        = data_if.c_v;
    end else if (result_if.valid & result_if.ready) begin
      pipe_valid_d = 1'b0;
    end
  end

  // Registered state
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pipe_valid_q <= 1'b0;
      opcode_q     <= '0;
      is_vector_q  <= 1'b0;
      a_s_q        <= '0;
      b_s_q        <= '0;
      c_s_q        <= '0;
      a_v_q        <= '0;
      b_v_q        <= '0;
      c_v_q        <= '0;
    end else begin
      pipe_valid_q <= pipe_valid_d;
      opcode_q     <= opcode_d;
      is_vector_q  <= is_vector_d;
      // data already assigned in comb section via _q nets
    end
  end

  // Compute stage (combinational over latched operands)
  logic [WIDTH-1:0]  res_s;
  logic [VEC_W-1:0]  res_v;

  function automatic logic [WIDTH-1:0] alu_scalar(opcode_e opc, logic [WIDTH-1:0] a, logic [WIDTH-1:0] b, logic [WIDTH-1:0] c);
    case (opc)
      OPC_ADD: alu_scalar = a + b;
      OPC_SUB: alu_scalar = a - b;
      OPC_MUL: alu_scalar = a * b;
      OPC_MAC: alu_scalar = (a * b) + c;
      default: alu_scalar = '0;
    endcase
  endfunction

  function automatic logic [WIDTH-1:0] lane_op(opcode_e opc, logic [WIDTH-1:0] a, logic [WIDTH-1:0] b, logic [WIDTH-1:0] c);
    lane_op = alu_scalar(opc, a, b, c);
  endfunction

  // Vector lane-wise operation
  genvar i;
  generate
    for (i = 0; i < LANES; i++) begin : g_vec
      wire [WIDTH-1:0] a_lane = a_v_q[i*WIDTH +: WIDTH];
      wire [WIDTH-1:0] b_lane = b_v_q[i*WIDTH +: WIDTH];
      wire [WIDTH-1:0] c_lane = c_v_q[i*WIDTH +: WIDTH];
      wire [WIDTH-1:0] r_lane = lane_op(opcode_e'(opcode_q), a_lane, b_lane, c_lane);
      assign res_v[i*WIDTH +: WIDTH] = r_lane;
    end
  endgenerate

  // Scalar result
  assign res_s = alu_scalar(opcode_e'(opcode_q), a_s_q, b_s_q, c_s_q);

  // Output handshake and registers
  assign result_if.valid    = pipe_valid_q;
  assign result_if.result_s = is_vector_q ? '0 : res_s;
  assign result_if.result_v = is_vector_q ? res_v : '0;

endmodule: gpu_shader_core


