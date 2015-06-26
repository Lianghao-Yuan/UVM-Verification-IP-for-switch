//
//  Module: Switch environment configuration
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 06/22/2015
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
`ifndef SWITCH_ENV_CONFIG_SVH
`define SWITCH_ENV_CONFIG_SVH

class switch_env_config extends uvm_object;
//
// UVM factory registration
`uvm_object_utils(switch_env_config)

// --------------------------
// Data member
// --------------------------
// Configuration objects of children's
switch_agent_config m_agent_cfg;

function new(string name = "switch_env_config");
  super.new(name);
endfunction: new

endclass: switch_env_config
`endif // SWITCH_ENV_CONFIG_SVH

