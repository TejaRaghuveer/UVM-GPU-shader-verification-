// Driver skeleton
class gpu_driver extends uvm_driver#(gpu_seq_item);
  `uvm_component_utils(gpu_driver)

  gpu_agent_config cfg;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(gpu_agent_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "gpu_agent_config not found via config_db")
    end
    if (cfg.instr_vif == null || cfg.data_vif == null) begin
      `uvm_fatal(get_type_name(), "virtual interfaces not set in cfg")
    end
    `uvm_info(get_type_name(),
              $sformatf("Driver got instr_vif=%p data_vif=%p",
                        cfg.instr_vif, cfg.data_vif),
              UVM_MEDIUM)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    drive_reset();
    forever begin
      gpu_seq_item tr;
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      seq_item_port.item_done();
    end
  endtask

  task drive_reset();
    cfg.instr_vif.valid = 1'b0;
    cfg.data_vif.valid  = 1'b0;
    cfg.instr_vif.opcode    = '0;
    cfg.instr_vif.is_vector = '0;
    cfg.data_vif.a_s = '0;
    cfg.data_vif.b_s = '0;
    cfg.data_vif.c_s = '0;
    cfg.data_vif.a_v = '0;
    cfg.data_vif.b_v = '0;
    cfg.data_vif.c_v = '0;
  endtask

  task drive_item(gpu_seq_item tr);
    // Wait for reset release
    @(posedge cfg.instr_vif.clk);
    wait (cfg.instr_vif.rst_n === 1'b1);

    // Drive instruction and data; assert valids and hold until both ready observed
    if ($test$plusargs("GPU_DBG")) begin
      `uvm_info(get_type_name(),
                $sformatf("DRIVE: opcode=%0d is_vector=%0d a_s=%h b_s=%h c_s=%h a_v=%h b_v=%h c_v=%h",
                          tr.opcode, tr.is_vector, tr.a_s, tr.b_s, tr.c_s, tr.a_v, tr.b_v, tr.c_v),
                UVM_HIGH)
    end
    cfg.instr_vif.opcode    = tr.opcode;
    cfg.instr_vif.is_vector = tr.is_vector;
    cfg.data_vif.a_s = tr.a_s;
    cfg.data_vif.b_s = tr.b_s;
    cfg.data_vif.c_s = tr.c_s;
    cfg.data_vif.a_v = tr.a_v;
    cfg.data_vif.b_v = tr.b_v;
    cfg.data_vif.c_v = tr.c_v;

    cfg.instr_vif.valid = 1'b1;
    cfg.data_vif.valid  = 1'b1;

    // Wait until handshake completes (both ready high in same cycle)
    do @(posedge cfg.instr_vif.clk);
    while (!(cfg.instr_vif.ready && cfg.data_vif.ready));

    // Deassert valids after handshake
    @(posedge cfg.instr_vif.clk);
    cfg.instr_vif.valid = 1'b0;
    cfg.data_vif.valid  = 1'b0;
  endtask
endclass: gpu_driver
