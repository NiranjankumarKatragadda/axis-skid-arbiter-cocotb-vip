# AXI4-Stream 2-to-1 Arbiter & Skid Buffer Cocotb VIP

[[https://github.com/NiranjankumarKatragadda/axis-skid-arbiter-cocotb-vip/actions/workflows/ci.yml/badge.svg]](https://github.com/NiranjankumarKatragadda/axis-skid-arbiter-cocotb-vip/actions/workflows/ci.yml)

Synthesizable packet-locked 2-to-1 Round-Robin AXI4-Stream arbiter + registered skid buffer (`src/axis_skid_arbiter.v`), verified with `cocotbext-axi` (`AxiStreamSource` / `AxiStreamSink` under randomized `tready` backpressure) across **Verilator** and **Icarus Verilog**.

## Quick start
    make -C tb SIM=verilator
    make -C tb SIM=icarus

## Need something similar?
NK Verif Labs offers custom Cocotb VIPs, dual-sim CI, and RTL-to-GDSII services ([nk-verif-labs](https://github.com/nk-verif-labs)). Email **nkveriflabs@gmail.com**.
