`uvm_analysis_imp_decl(_req)
`uvm_analysis_imp_decl(_rsp)

class gpu_scoreboard extends uvm_component;
  `uvm_component_utils(gpu_scoreboard)

  // Expectation and actual queues to align transactions across pipeline latency
  gpu_seq_item exp_q[$];
  gpu_seq_item act_q[$];

  uvm_analysis_imp_req#(gpu_seq_item, gpu_scoreboard) req_export;
  uvm_analysis_imp_rsp#(gpu_seq_item, gpu_scoreboard) rsp_export;

  int unsigned num_compares;
  int unsigned num_mismatches;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    req_export = new("req_export", this);
    rsp_export = new("rsp_export", this);
  endfunction

  // Expectation path: enqueue request info
  function void write_req(gpu_seq_item t);
    exp_q.push_back(t.clone());
    compare_if_ready();
  endfunction

  // Actual path: enqueue observed results
  function void write_rsp(gpu_seq_item t);
    act_q.push_back(t.clone());
    compare_if_ready();
  endfunction

  // Align FIFO entries and compare once both sides are ready
  function void compare_if_ready();
    if (exp_q.size() == 0 || act_q.size() == 0)
      return;

    gpu_seq_item exp = exp_q.pop_front();
    gpu_seq_item act = act_q.pop_front();

    bit [gpu_ref_model::WIDTH-1:0] exp_s;
    bit [gpu_ref_model::VEC_W-1:0] exp_v;
    gpu_ref_model::compute_expected(exp, exp_s, exp_v);

    num_compares++;
    if (exp.is_vector) begin
      if (act.result_v !== exp_v) begin
        num_mismatches++;
        `uvm_error(get_type_name(),
                   $sformatf("VECTOR MISMATCH: opcode=%0d exp=%h got=%h",
                             exp.opcode, exp_v, act.result_v))
      end else begin
        `uvm_info(get_type_name(),
                  $sformatf("Vector PASS opcode=%0d res=%h",
                            exp.opcode, act.result_v),
                  UVM_LOW)
      end
    end else begin
      if (act.result_s !== exp_s) begin
        num_mismatches++;
        `uvm_error(get_type_name(),
                   $sformatf("SCALAR MISMATCH: opcode=%0d exp=%h got=%h",
                             exp.opcode, exp_s, act.result_s))
      end else begin
        `uvm_info(get_type_name(),
                  $sformatf("Scalar PASS opcode=%0d res=%h",
                            exp.opcode, act.result_s),
                  UVM_LOW)
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),
              $sformatf("Compares=%0d Mismatches=%0d",
                        num_compares, num_mismatches),
              UVM_LOW)
    if (num_mismatches == 0 && num_compares > 0) begin
      `uvm_info(get_type_name(), "All comparisons PASSED", UVM_LOW)
    end
  endfunction
endclass: gpu_scoreboard
