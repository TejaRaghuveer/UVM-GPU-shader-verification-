// Scoreboard skeleton
class gpu_scoreboard extends uvm_component;
  `uvm_component_utils(gpu_scoreboard)

  uvm_analysis_imp#(gpu_seq_item, gpu_scoreboard) analysis_export;
  int unsigned num_compares;
  int unsigned num_mismatches;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export", this);
  endfunction

  function void write(gpu_seq_item t);
    bit [gpu_ref_model::WIDTH-1:0] exp_s;
    bit [gpu_ref_model::VEC_W-1:0] exp_v;
    gpu_ref_model::compute_expected(t, exp_s, exp_v);
    num_compares++;
    if (t.is_vector) begin
      if (t.result_v !== exp_v) begin
        num_mismatches++;
        `uvm_error(get_type_name(), $sformatf("VECTOR MISMATCH: opcode=%0d exp=%h got=%h", t.opcode, exp_v, t.result_v))
      end else begin
        `uvm_info(get_type_name(), $sformatf("Vector PASS opcode=%0d res=%h", t.opcode, t.result_v), UVM_MEDIUM)
      end
    end else begin
      if (t.result_s !== exp_s) begin
        num_mismatches++;
        `uvm_error(get_type_name(), $sformatf("SCALAR MISMATCH: opcode=%0d exp=%h got=%h", t.opcode, exp_s, t.result_s))
      end else begin
        `uvm_info(get_type_name(), $sformatf("Scalar PASS opcode=%0d res=%h", t.opcode, t.result_s), UVM_MEDIUM)
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Compares=%0d Mismatches=%0d", num_compares, num_mismatches), UVM_LOW)
    if (num_mismatches == 0 && num_compares > 0) begin
      `uvm_info(get_type_name(), "All comparisons PASSED", UVM_LOW)
    end
  endfunction
endclass: gpu_scoreboard
