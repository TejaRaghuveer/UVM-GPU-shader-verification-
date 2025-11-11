// Sequencer skeleton
class gpu_sequencer extends uvm_sequencer#(gpu_seq_item);
  `uvm_component_utils(gpu_sequencer)
  
  gpu_agent_config cfg;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(gpu_agent_config)::get(this, "", "cfg", cfg)) begin
      cfg = null;
      `uvm_warning(get_type_name(), "gpu_agent_config not found in sequencer; proceeding with defaults")
    end
  endfunction
endclass: gpu_sequencer
