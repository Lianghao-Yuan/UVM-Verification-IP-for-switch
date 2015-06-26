//
//  Module: Switch coverage
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
`ifndef SWITCH_COVERAGE_SVH
`define SWITCH_COVERAGE_SVH

class switch_coverage extends uvm_subscriber #(switch_packet_seq_item);
// UVM factory registration
//
`uvm_component_utils(switch_coverage)
// -------------------------------
// Data member
// -------------------------------
switch_packet_seq_item pkt;
bit [7:0] device_addr[4]; 
// -------------------------------
// Covergroup: switch_cg
// -------------------------------
covergroup switch_cg;
  option.per_instance = 1;
  // Whether different length (long / short) been covered
  length: coverpoint pkt.length{
    bins short_0_127 = {[0:127]};
    bins long_128_255 = {[128:255]};
  }

  // Whether all four addresses been covered
  da: coverpoint pkt.da{
    bins addr0 = {device_addr[0]};
    bins addr1 = {device_addr[1]};
    bins addr2 = {device_addr[2]};
    bins addr3 = {device_addr[3]};
  }

  // Whether good and bad fcs covered
  fcs_kind: coverpoint pkt.fcs_kind;

  // Cross coverage
  all_cross: cross length, da, fcs_kind;
  
endgroup: switch_cg

// -------------------------------
// Methods
// -------------------------------
extern function new(string name = "switch_coverage", uvm_component parent = null);
extern function void write(switch_packet_seq_item t);


endclass: switch_coverage
// -------------------------------
// Extern methods
// -------------------------------
function switch_coverage::new(string name = "switch_coverage", uvm_component parent = null);
  super.new(name, parent);
  switch_cg = new();
endfunction: new

function void switch_coverage::write(switch_packet_seq_item t);
  if(t == null) begin
    `uvm_error("write", "Null object")
  end
  if(!$cast(pkt, t.clone())) begin
    `uvm_error("write", "Failed to cast")
  end
  switch_cg.sample();
endfunction: write

`endif // SWITCH_COVERAGE_SVH

