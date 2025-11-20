// UVM package for GPU Shader testbench
package gpu_shader_tb_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Interface types (ensure visibility for virtual interface declarations)
  `include "dut/if/shader_instr_if.sv"
  `include "dut/if/shader_data_if.sv"
  `include "dut/if/shader_result_if.sv"

  // Include all components
  `include "scoreboard/gpu_ref_model.sv"
  `include "agent/seq_item/gpu_seq_item.sv"
  `include "agent/driver/gpu_driver.sv"
  `include "agent/monitor/gpu_monitor.sv"
  `include "agent/sequencer/gpu_sequencer.sv"
  `include "agent/config/gpu_agent_config.sv"
  `include "agent/gpu_agent.sv"
  `include "env/gpu_env.sv"
  `include "scoreboard/gpu_scoreboard.sv"
  `include "coverage/gpu_coverage.sv"
  `include "sequences/base_seq.sv"
  `include "sequences/gpu_scalar_seq.sv"
  `include "sequences/gpu_vector_seq.sv"
  `include "sequences/gpu_mixed_seq.sv"
  `include "sequences/gpu_directed_smoke_seq.sv"
  `include "sequences/gpu_edge_cases_seq.sv"
  `include "sequences/gpu_random_stress_seq.sv"
  `include "sequences/gpu_handshake_seq.sv"
  `include "sequences/gpu_opcode_mode_seq.sv"
  `include "sequences/gpu_scalar_edge_seq.sv"
  `include "sequences/gpu_vector_lane_seq.sv"
  `include "sequences/gpu_mac_stress_seq.sv"
  `include "sequences/gpu_ready_valid_seq.sv"

  // Basic test skeleton
  class gpu_base_test extends uvm_test;
    `uvm_component_utils(gpu_base_test)

    gpu_env env_h;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env_h = gpu_env::type_id::create("env_h", this);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      // TODO: start a sequence on env's sequencer when available
      phase.drop_objection(this);
    endtask
  endclass: gpu_base_test

  class gpu_handshake_test extends gpu_base_test;
    `uvm_component_utils(gpu_handshake_test)

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      gpu_handshake_seq seq = gpu_handshake_seq::type_id::create("handshake_seq");
      seq.start(env_h.agent_h.sqr_h);
      phase.drop_objection(this);
    endtask
  endclass: gpu_handshake_test

  class gpu_opcode_mode_test extends gpu_base_test;
    `uvm_component_utils(gpu_opcode_mode_test)
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      gpu_opcode_mode_seq seq = gpu_opcode_mode_seq::type_id::create("opcode_mode_seq");
      seq.start(env_h.agent_h.sqr_h);
      phase.drop_objection(this);
    endtask
  endclass: gpu_opcode_mode_test

  class gpu_scalar_edge_test extends gpu_base_test;
    `uvm_component_utils(gpu_scalar_edge_test)
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      gpu_scalar_edge_seq seq = gpu_scalar_edge_seq::type_id::create("scalar_edge_seq");
      seq.start(env_h.agent_h.sqr_h);
      phase.drop_objection(this);
    endtask
  endclass: gpu_scalar_edge_test

  class gpu_vector_lane_test extends gpu_base_test;
    `uvm_component_utils(gpu_vector_lane_test)
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      gpu_vector_lane_seq seq = gpu_vector_lane_seq::type_id::create("vector_lane_seq");
      seq.start(env_h.agent_h.sqr_h);
      phase.drop_objection(this);
    endtask
  endclass: gpu_vector_lane_test

  class gpu_mac_stress_test extends gpu_base_test;
    `uvm_component_utils(gpu_mac_stress_test)
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      gpu_mac_stress_seq seq = gpu_mac_stress_seq::type_id::create("mac_stress_seq");
      seq.start(env_h.agent_h.sqr_h);
      phase.drop_objection(this);
    endtask
  endclass: gpu_mac_stress_test

endpackage: gpu_shader_tb_pkg


