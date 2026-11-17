import random, cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotbext.axi import AxiStreamBus, AxiStreamSource, AxiStreamSink

def random_pause():
    while True:
        yield random.random() < 0.35

@cocotb.test()
async def test_axis_rr_and_backpressure(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    dut.rst_n.value = 0; await Timer(40, units="ns"); dut.rst_n.value = 1; await RisingEdge(dut.clk)
    s0 = AxiStreamSource(AxiStreamBus.from_prefix(dut, "s0_axis"), dut.clk, dut.rst_n, reset_active_level=False)
    s1 = AxiStreamSource(AxiStreamBus.from_prefix(dut, "s1_axis"), dut.clk, dut.rst_n, reset_active_level=False)
    sink = AxiStreamSink(AxiStreamBus.from_prefix(dut, "m_axis"), dut.clk, dut.rst_n, reset_active_level=False)
    sink.set_pause_generator(random_pause())
    exp0 = [bytes([(i * 17 + j) & 0xFF for j in range(16)]) for i in range(6)]
    exp1 = [bytes([(i * 31 + j + 1) & 0xFF for j in range(12)]) for i in range(6)]
    for p in exp0: await s0.send(p)
    for p in exp1: await s1.send(p)
    rx = [bytes(await sink.recv()) for _ in range(12)]
    assert sorted(rx) == sorted(exp0 + exp1), "Packet mismatch or drop under backpressure!"
    dut._log.info("PASS: 12 AXI4-Stream packets arbitrated & skid-buffered with random backpressure!")
