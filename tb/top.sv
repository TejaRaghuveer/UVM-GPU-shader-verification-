// Testbench top for GPU Shader
module tb_top;
  import uvm_pkg::*;
  import gpu_shader_tb_pkg::*;

  // TODO: instantiate DUT and environment
  // Clock and reset
  logic clk;
  logic rst_n;

  localparam int WIDTH    = 32;
  localparam int LANES    = 4;
  localparam int OPCODE_W = 4;

  // Interfaces
  shader_instr_if #(OPCODE_W) instr_if (.*);
  shader_data_if  #(WIDTH, LANES) data_if (.*);
  shader_result_if#(WIDTH, LANES) result_if (.*);

  // Tie-offs for result ready (agent/monitor may override via virtual IF)
  assign result_if.ready = 1'b1;

  // DUT instance
  gpu_shader_core #(
    .WIDTH    (WIDTH),
    .LANES    (LANES),
    .OPCODE_W (OPCODE_W)
  ) dut (
    .clk      (clk),
    .rst_n    (rst_n),
    .instr_if (instr_if),
    .data_if  (data_if),
    .result_if(result_if)
  );

  // Clock generation
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk; // 100MHz
  end

  // Reset sequence
  initial begin
    rst_n = 1'b0;
    repeat (5) @(posedge clk);
    rst_n = 1'b1;
  end

  // Optional VCD waveform dump (+VCD)
  initial begin
    if ($test$plusargs("VCD")) begin
      $dumpfile("waves.vcd");
      $dumpvars(0, tb_top);
    end
  end

  initial begin
    // Publish virtual interfaces for UVM environment/agents
    uvm_config_db#(virtual shader_instr_if)::set(null, "*", "instr_vif", instr_if);
    uvm_config_db#(virtual shader_data_if )::set(null, "*", "data_vif",  data_if);
    uvm_config_db#(virtual shader_result_if)::set(null, "*", "result_vif", result_if);

    run_test("gpu_base_test");
  end
endmodule: tb_top
