// Agent skeleton
class gpu_agent extends uvm_agent;
  `uvm_component_utils(gpu_agent)

  gpu_agent_config cfg;
  gpu_sequencer    sqr_h;
  gpu_driver       drv_h;
  gpu_monitor      mon_h;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create or get config
    if (!uvm_config_db#(gpu_agent_config)::get(this, "", "cfg", cfg)) begin
      cfg = gpu_agent_config::type_id::create("cfg");
    end

    // Pull VIFs from testbench config_db and store into cfg
    void'(uvm_config_db#(virtual shader_instr_if)::get(this, "", "instr_vif", cfg.instr_vif));
    void'(uvm_config_db#(virtual shader_data_if )::get(this, "", "data_vif",  cfg.data_vif));
    void'(uvm_config_db#(virtual shader_result_if)::get(this, "", "result_vif", cfg.result_vif));

    // Make cfg available to children
    uvm_config_db#(gpu_agent_config)::set(this, "*", "cfg", cfg);

    // Components
    if (cfg.is_active == UVM_ACTIVE) begin
      sqr_h = gpu_sequencer::type_id::create("sqr_h", this);
      drv_h = gpu_driver   ::type_id::create("drv_h", this);
    end
    mon_h = gpu_monitor::type_id::create("mon_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.is_active == UVM_ACTIVE) begin
      drv_h.seq_item_port.connect(sqr_h.seq_item_export);
    end
  endfunction
endclass: gpu_agent
