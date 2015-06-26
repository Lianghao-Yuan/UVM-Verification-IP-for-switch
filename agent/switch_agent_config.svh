//
//  Module: Switch agent configuration
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 06/20/2015
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
`ifndef SWITCH_AGENT_CONFIG_SVH
`define SWITCH_AGENT_CONFIG_SVH

class switch_agent_config extends uvm_object;

// UVM factory registration macro
//
`uvm_object_utils(switch_agent_config)

// Virtual interfaces
virtual switch_input_if  input_intf;
virtual switch_mem_if    mem_intf;
virtual switch_output_if output_intf[4];

// ---------------------------
// Data members
// ---------------------------
// Is agent active or passive
uvm_active_passive_enum active = UVM_ACTIVE;
// Device port addres
bit [7:0] device_addr[4];
// Functional coverage enable
bit has_functional_coverage;

extern function new(string name = "switch_agent_config");

endclass: switch_agent_config

function switch_agent_config::new(string name = "switch_agent_config");
  super.new(name);
endfunction: new

`endif // SWITCH_AGENT_CONFIG_SVH
