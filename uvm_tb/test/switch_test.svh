//
//  Module: Switch test
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 06/23/2015
//  Copyright (C) 2015 Lianghao Yuan

//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//

`ifndef SWITCH_TEST_SVH
`define SWITCH_TEST_SVH

class switch_test extends uvm_test;
// UVM factory registration macro
`uvm_component_utils(switch_test)

// ------------------------------
// Component members
// ------------------------------
switch_env m_env;
switch_sequencer m_sequencer;
switch_1k_random_seq m_1k_random_seq;

// ------------------------------
// Data members
// ------------------------------
switch_env_config m_env_cfg;
switch_agent_config m_agent_cfg;

// ------------------------------
// Methods
// ------------------------------
extern function new(string name = "switch_test", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass: switch_test
// ------------------------------
// Extern methods
// ------------------------------
function switch_test::new(string name = "switch_test", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void switch_test::build_phase(uvm_phase phase);
  m_env_cfg = switch_env_config::type_id::create("m_env_cfg");
  // First configure m_env_cfg, then create env
  m_agent_cfg = switch_agent_config::type_id::create("m_agent_cfg");
  if(!uvm_config_db # (virtual switch_input_if)::get(this, "", "input_intf", m_agent_cfg.input_intf)) begin
    `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
  end
  // Configuring output interface one by one
  if(!uvm_config_db # (virtual switch_output_if)::get(this, "", "output_intf_0", m_agent_cfg.output_intf[0])) begin
    `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
  end
  if(!uvm_config_db # (virtual switch_output_if)::get(this, "", "output_intf_1", m_agent_cfg.output_intf[1])) begin
    `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
  end
  if(!uvm_config_db # (virtual switch_output_if)::get(this, "", "output_intf_2", m_agent_cfg.output_intf[2])) begin
    `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
  end
  if(!uvm_config_db # (virtual switch_output_if)::get(this, "", "output_intf_3", m_agent_cfg.output_intf[3])) begin
    `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
  end

  if(!uvm_config_db # (virtual switch_mem_if)::get(this, "", "mem_intf", m_agent_cfg.mem_intf)) begin
    `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
  end
  // Enable functional coverage
  m_agent_cfg.has_functional_coverage = 1;
  // Initialize port addresses 
  foreach(m_agent_cfg.device_addr[i]) begin
    m_agent_cfg.device_addr[i] = i;
  end
  m_env_cfg.m_agent_cfg = m_agent_cfg;
  // Pass m_env_cfg and create m_env
  uvm_config_db # (switch_env_config)::set(this, "m_env", "switch_env_config", m_env_cfg);
  m_env = switch_env::type_id::create("m_env", this);
endfunction: build_phase

function void switch_test::end_of_elaboration_phase(uvm_phase phase);
  m_sequencer = m_env.m_sequencer;
endfunction: end_of_elaboration_phase

task switch_test::run_phase(uvm_phase phase);
  m_1k_random_seq = new("m_1k_random_seq");
  phase.raise_objection(this);
  m_1k_random_seq.start(m_sequencer);
  phase.drop_objection(this);
endtask: run_phase

`endif // SWITCH_TEST_SVH

