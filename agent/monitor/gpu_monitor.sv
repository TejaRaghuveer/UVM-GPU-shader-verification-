// Monitor skeleton
class gpu_monitor extends uvm_component;
  `uvm_component_utils(gpu_monitor)

  gpu_agent_config cfg;
  uvm_analysis_port#(gpu_seq_item) req_ap;
  uvm_analysis_port#(gpu_seq_item) rsp_ap;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    req_ap = new("req_ap", this);
    rsp_ap = new("rsp_ap", this);
    if (!uvm_config_db#(gpu_agent_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "gpu_agent_config not found via config_db")
    end
    if (cfg.instr_vif == null || cfg.data_vif == null || cfg.result_vif == null) begin
      `uvm_fatal(get_type_name(), "one or more virtual interfaces not set in cfg")
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      sample_requests();
      sample_results();
    join
  endtask

  // Publish instruction+operand transactions when both instr/data handshakes complete
  task sample_requests();
    forever begin
      @(posedge cfg.instr_vif.clk);
      if (cfg.instr_vif.rst_n) begin
        bit fire = (cfg.instr_vif.valid && cfg.instr_vif.ready &&
                    cfg.data_vif.valid  && cfg.data_vif.ready);
        if (fire) begin
          gpu_seq_item it = gpu_seq_item::type_id::create("req_cap",, get_full_name());
          it.opcode    = gpu_seq_item::opcode_e'(cfg.instr_vif.opcode);
          it.is_vector = cfg.instr_vif.is_vector;
          it.a_s = cfg.data_vif.a_s;
          it.b_s = cfg.data_vif.b_s;
          it.c_s = cfg.data_vif.c_s;
          it.a_v = cfg.data_vif.a_v;
          it.b_v = cfg.data_vif.b_v;
          it.c_v = cfg.data_vif.c_v;
          req_ap.write(it);
        end
      end
    end
  endtask

  // Publish result observations when DUT returns data
  task sample_results();
    forever begin
      @(posedge cfg.result_vif.clk);
      if (cfg.result_vif.rst_n) begin
        if (cfg.result_vif.valid && cfg.result_vif.ready) begin
          gpu_seq_item it = gpu_seq_item::type_id::create("rsp_cap",, get_full_name());
          it.result_s = cfg.result_vif.result_s;
          it.result_v = cfg.result_vif.result_v;
          if ($test$plusargs("GPU_DBG")) begin
            `uvm_info(get_type_name(),
                      $sformatf("MON: result_s=%h result_v=%h",
                                it.result_s, it.result_v),
                      UVM_HIGH)
          end
          rsp_ap.write(it);
        end
      end
    end
  endtask
endclass: gpu_monitor
