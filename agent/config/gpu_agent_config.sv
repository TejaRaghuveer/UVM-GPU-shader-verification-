// Agent configuration for GPU shader agent
class gpu_agent_config extends uvm_object;
  `uvm_object_utils(gpu_agent_config)

  // Active/passive
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Virtual interfaces
  virtual shader_instr_if   instr_vif;
  virtual shader_data_if    data_vif;
  virtual shader_result_if  result_vif;

  function new(string name="gpu_agent_config");
    super.new(name);
  endfunction
endclass: gpu_agent_config


