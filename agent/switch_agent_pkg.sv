//
//  Module: Switch agent package 
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

package switch_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  // Macros and configuration
  `include "switch_agent_macros.svh"
  `include "switch_agent_config.svh"
  // Components
  `include "switch_packet_seq_item.svh"
  `include "switch_sequencer.svh"
  `include "switch_scoreboard.svh"
  `include "switch_receiver.svh"
  `include "switch_driver.svh"
  `include "switch_coverage.svh"
  `include "switch_agent.svh"
  
endpackage: switch_agent_pkg
