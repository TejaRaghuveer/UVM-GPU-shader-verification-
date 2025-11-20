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

  // Optional waveform dumps (+VCD, +WLF, +FSDB)
  initial begin
    if ($test$plusargs("VCD")) begin
      $dumpfile("waves.vcd");
      $dumpvars(0, tb_top);
    end
`ifdef DUMP_WLF
    if ($test$plusargs("WLF")) begin
      $wlfdumpvars;
    end
`endif
`ifdef DUMP_FSDB
    if ($test$plusargs("FSDB")) begin
      $fsdbDumpfile("waves.fsdb");
      $fsdbDumpvars(0, tb_top);
    end
`endif
  end

  task automatic bind_agent_vifs(string agent_path);
    uvm_config_db#(virtual shader_instr_if)::set(null, agent_path, "instr_vif", instr_if);
    uvm_config_db#(virtual shader_data_if )::set(null, agent_path, "data_vif",  data_if);
    uvm_config_db#(virtual shader_result_if)::set(null, agent_path, "result_vif", result_if);
    `uvm_info("CFG_BIND",
              $sformatf("Bound VIFs to %s instr=%p data=%p result=%p",
                        agent_path, instr_if, data_if, result_if),
              UVM_LOW)
  endtask

  initial begin
    bind_agent_vifs("uvm_test_top.env_h.agent_h");

    if ($test$plusargs("PRINT_TOPO")) begin
      #1;
      uvm_root::get().print_topology();
    end
    if ($test$plusargs("PRINT_CONFIG")) begin
      #1;
      uvm_root::get().print_config();
    end
    if ($test$plusargs("UVM_CFG_TRACE")) begin
      uvm_root::get().print_config(1);
    end

    string testname;
    if (!uvm_cmdline_processor::get_inst().get_arg_value("+UVM_TESTNAME=", testname)) begin
      testname = "gpu_base_test";
    end
    `uvm_info("TB_TOP",
              $sformatf("Running test: %s", testname),
              UVM_LOW)
    run_test(testname);
  end
endmodule: tb_top
