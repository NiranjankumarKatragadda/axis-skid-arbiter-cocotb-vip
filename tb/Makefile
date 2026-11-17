SIM ?= verilator
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += $(PWD)/../src/axis_skid_arbiter.v
TOPLEVEL := axis_skid_arbiter
MODULE := test_axis_vip
ifeq ($(SIM),verilator)
EXTRA_ARGS += -Wno-fatal -Wno-WIDTH -Wno-lint -Wno-style
endif
include $(shell cocotb-config --makefiles)/Makefile.sim
