// Environment skeleton
class gpu_env extends uvm_env;
  uvm_component_utils(gpu_env)
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
endclass: gpu_env
