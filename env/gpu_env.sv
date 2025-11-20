// Environment tying together agent, scoreboard, and coverage
class gpu_env extends uvm_env;
  `uvm_component_utils(gpu_env)

  gpu_agent      agent_h;
  gpu_scoreboard sb_h;
  gpu_coverage   cov_h;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent_h = gpu_agent     ::type_id::create("agent_h", this);
    sb_h    = gpu_scoreboard::type_id::create("sb_h", this);
    cov_h   = gpu_coverage  ::type_id::create("cov_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Request path fans out to scoreboard (expectations) and coverage
    agent_h.mon_h.req_ap.connect(sb_h.req_export);
    agent_h.mon_h.req_ap.connect(cov_h.analysis_export);
    // Result path drives scoreboard actual queue
    agent_h.mon_h.rsp_ap.connect(sb_h.rsp_export);
  endfunction
endclass: gpu_env
