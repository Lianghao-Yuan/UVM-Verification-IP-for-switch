//
//  Module: Switch random sequence
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
`ifndef SWITCH_1K_RANDOM_SEQ_SVH
`define SWITCH_1K_RANDOM_SEQ_SVH

class switch_1k_random_seq extends uvm_sequence #(switch_packet_seq_item);
//
// UVM factory registration
`uvm_object_utils(switch_1k_random_seq)

function new(string name = "switch_1k_random_seq");
  super.new(name);
endfunction: new

task body();
  // How many packets to be generated
  int no_packets;
  switch_packet_seq_item packet;
  no_packets = 1000;
  // Instantiate a packet
  packet = switch_packet_seq_item::type_id::create("packet");
  // Generate packets
  for(int i = 0; i < no_packets; i++) begin
    start_item(packet);
    if(!packet.randomize()) begin
      `uvm_error("body", "Unable to randomize the switch_packet_seq_item")
    end
    finish_item(packet);
    `uvm_info("body", "Generated a packet", UVM_LOW)
  end

endtask: body

endclass: switch_1k_random_seq
`endif // SWITCH_1K_RANDOM_SEQ_SVH
