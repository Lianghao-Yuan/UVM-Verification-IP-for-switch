# You may change these configuration to fit your need
UVM_VERBOSITY = UVM_NONE
# You HAVE TO change this to your UVM package path
UVM_HOME = /nethome/lyuan39/uvm-1.2
# Files declaration
SWITCH_RTL = ../rtl/switch.v 

SWITCH_AGENT = ../agent/switch_agent_pkg.sv \
               ../agent/switch_output_if.sv \
               ../agent/switch_mem_if.sv \
               ../agent/switch_input_if.sv
SWITCH_ENV = ../uvm_tb/env/switch_env_pkg.sv
SWITCH_RTL_WRAPPER = ../uvm_tb/rtl_wrapper/switch_wrapper.sv
SWITCH_SEQUENCE = ../uvm_tb/sequence/switch_seq_pkg.sv
SWITCH_TEST = ../uvm_tb/test/switch_test_pkg.sv
SWITCH_TB = ../uvm_tb/tb/switch_tb.sv

# Directory declaration
SWITCH_RTL_DIR = +incdir+../rtl
SWITCH_AGENT_DIR = +incdir+../agent
SWITCH_ENV_DIR = +incdir+../uvm_tb/env
SWITCH_RTL_WRAPPER_DIR = +incdir+../uvm_tb/rtl_wrapper
SWITCH_SEQUENCE_DIR = +incdir+../uvm_tb/sequence
SWITCH_TEST_DIR = +incdir+../uvm_tb/test
SWITCH_TB_DIR = +incdir+../uvm_tb/tb

# Other declarations
UVM_TESTNAME = switch_test

# VCS related commands
VCS = vcs
VCS_OPTS = -sverilog -timescale=1ns/1ns +acc +vpi +v2k -full64
UVM_OPTS = +incdir+$(UVM_HOME)/src \
                   $(UVM_HOME)/src/uvm.sv \
                   $(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS
DEBUG_OPTS = -cm line -debug_all

INCDIRS = $(SWITCH_RTL_DIR) \
          $(SWITCH_AGENT_DIR) \
          $(SWITCH_ENV_DIR) \
          $(SWITCH_RTL_WRAPPER_DIR) \
          $(SWITCH_SEQUENCE_DIR) \
          $(SWITCH_TEST_DIR) \
          $(SWITCH_TB_DIR)

SRC_FILES = $(SWITCH_RTL) \
            $(SWITCH_AGENT) \
            $(SWITCH_ENV) \
            $(SWITCH_RTL_WRAPPER) \
            $(SWITCH_SEQUENCE) \
            $(SWITCH_TEST) \
            $(SWITCH_TB)

.PHONY: vcs_std run_test vcs_urg vcs_debug run_test_debug clean

all: vcs_std run_test vcs_urg 

vcs_std:
	$(VCS) $(VCS_OPTS) $(UVM_OPTS) $(INCDIRS) $(SRC_FILES)

run_test:
	./simv +UVM_TESTNAME=$(UVM_TESTNAME) +UVM_VERBOSITY=$(UVM_VERBOSITY)

vcs_urg:
	urg -dir simv.vdb
# Debug options
vcs_debug:
	$(VCS) $(VCS_OPTS) $(UVM_OPTS) $(DEBUG_OPTS) $(INCDIRS) $(SRC_FILES)

run_test_debug:
	./simv +UVM_TESTNAME=$(UVM_TESTNAME) +UVM_VERBOSITY=$(UVM_VERBOSITY) -cm line+code+tgl+path	
clean:
	rm -rf *~ core csrc simv* vc_hdrs.h ucli.key urg* *.log dump* DVE*


