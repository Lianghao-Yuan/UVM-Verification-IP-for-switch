//
//  Module: Switch sequencer
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
`ifndef SWITCH_SEQUENCER_SVH
`define SWITCH_SEQUENCER_SVH

class switch_sequencer extends uvm_sequencer #(switch_packet_seq_item, switch_packet_seq_item);

// UVM factory registration macro
//
`uvm_component_utils(switch_sequencer)

function new (string name = "switch_sequencer", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

endclass: switch_sequencer

`endif // SWITCH_SEQUENCER_SVH
