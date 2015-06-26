//
//  Module: Switch environment package
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
`ifndef SWITCH_ENV_SVH
`define SWITCH_ENV_SVH

class switch_env extends uvm_env;
//
// UVM factory registration
`uvm_component_utils(switch_env)
// -----------------------------
// Component member
// -----------------------------
// Children components
switch_agent m_agent;
switch_sequencer m_sequencer;

// -----------------------------
// Data member
// -----------------------------
switch_env_config m_cfg;

// -----------------------------
// Methods
// -----------------------------
extern function new(string name = "switch_env", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);

endclass: switch_env
// -----------------------------
// Extern methods
// -----------------------------
function switch_env::new(string name = "switch_env", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void switch_env::build_phase(uvm_phase phase);
  m_agent = switch_agent::type_id::create("m_agent", this);
  // Configuration
  if(!uvm_config_db # (switch_env_config)::get(this, "", "switch_env_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to find switch_env_config in uvm_config_db")
  end
  // Set configuration for switch_agent
  uvm_config_db # (switch_agent_config)::set(this, "m_agent", "switch_agent_config", m_cfg.m_agent_cfg);
endfunction: build_phase

function void switch_env::end_of_elaboration_phase(uvm_phase phase);
  m_sequencer = m_agent.m_sequencer;
endfunction: end_of_elaboration_phase

`endif // SWITCH_ENV_SVH
