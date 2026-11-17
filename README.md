# AXI4-Stream 2-to-1 Arbiter & Skid Buffer Cocotb VIP

[[https://github.com/NiranjankumarKatragadda/axis-skid-arbiter-cocotb-vip/actions/workflows/ci.yml/badge.svg]](https://github.com/NiranjankumarKatragadda/axis-skid-arbiter-cocotb-vip/actions/workflows/ci.yml)

Synthesizable packet-locked 2-to-1 Round-Robin AXI4-Stream arbiter + registered skid buffer (`src/axis_skid_arbiter.v`), verified with `cocotbext-axi` (`AxiStreamSource` / `AxiStreamSink` under randomized `tready` backpressure) across **Verilator** and **Icarus Verilog**.
