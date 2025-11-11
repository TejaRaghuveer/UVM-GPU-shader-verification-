# Diagrams — GPU Shader Core and UVM Testbench

## GPU Shader Core (simplified)

```mermaid
flowchart LR
  subgraph TB["GPU Shader Core (DUT)"]
    INSTR["shader_instr_if
    - opcode[3:0]
    - is_vector
    - valid/ready"]
    DATA["shader_data_if
    - a_s, b_s, c_s
    - a_v, b_v, c_v
    - valid/ready"]
    CORE["gpu_shader_core
    - ADD/SUB/MUL/MAC
    - scalar + 4-lane vector
    - 1-entry pipeline"]
    RES["shader_result_if
    - result_s
    - result_v
    - valid/ready"]
    INSTR --> CORE
    DATA --> CORE
    CORE --> RES
  end
```

Notes:
- Instruction and data requests use ready/valid; the core accepts when both are ready in the same cycle.
- `is_vector=0` selects scalar datapath; `is_vector=1` selects lane-wise vector operations.
- Results return with their own ready/valid handshake.

## UVM Testbench Components

```mermaid
flowchart TB
  subgraph ENV["gpu_env (UVM environment)"]
    AG["gpu_agent
    - gpu_sequencer
    - gpu_driver
    - gpu_monitor"]
    SB["gpu_scoreboard
    - golden reference model"]
    CVG["gpu_coverage
    - opcode/mode/operand bins"]
    AG -- analysis_port (transactions) --> SB
    AG -- analysis_port (transactions) --> CVG
  end

  SEQ["Sequences
  - directed (smoke/edges)
  - random (stress/mixed)"]

  SEQ -- start on --> AG

  subgraph IFs["Virtual Interfaces (from tb_top)"]
    VI1["virtual shader_instr_if"]
    VI2["virtual shader_data_if"]
    VI3["virtual shader_result_if"]
  end

  IFs --> AG
```

Notes:
- Sequences create `gpu_seq_item` transactions; the driver turns them into interface handshakes.
- The monitor observes DUT outputs and publishes completed transactions to the scoreboard and coverage.
- The scoreboard compares against a golden model; coverage guides stimulus toward unhit scenarios.

## End-to-end in the testbench top

```mermaid
sequenceDiagram
  participant SEQ as Sequence
  participant SQR as Sequencer
  participant DRV as Driver
  participant DUT as gpu_shader_core
  participant MON as Monitor
  participant SB as Scoreboard

  SEQ->>SQR: next transaction (opcode, is_vector, operands)
  SQR->>DRV: item (get_next_item)
  DRV->>DUT: instr_if/data_if valid with fields
  DUT-->>DRV: ready (when pipeline empty)
  DRV->>DUT: deassert valid (handshake complete)
  DUT-->>MON: result_if valid with result
  MON->>SB: transaction with observed results
  SB->>SB: compare vs golden model
```


