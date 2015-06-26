//
//  Module: Switch scoreboard
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
`ifndef SWITCH_SCOREBOARD_SVH
`define SWITCH_SCOREBOARD_SVH

class switch_scoreboard extends uvm_scoreboard;

// UVM factory registration macro
`uvm_component_utils(switch_scoreboard)
// uvm_analysis_imp_decl
`uvm_analysis_imp_decl(_rcvd_pkt)
`uvm_analysis_imp_decl(_sent_pkt)
// ----------------------------------
// Data members
// ----------------------------------
// Declare uvm_analysis_imp export
uvm_analysis_imp_rcvd_pkt # (switch_packet_seq_item, switch_scoreboard) rcvr2sb_export;
uvm_analysis_imp_sent_pkt # (switch_packet_seq_item, switch_scoreboard) drvr2sb_export;
// Analysis port for coverage
uvm_analysis_port # (switch_packet_seq_item) sb2coverage_ap;
// Queue for storing packets
switch_packet_seq_item packet_queue[$];
// ----------------------------------
// Methods
// ----------------------------------

extern function new(string name = "switch_scoreboard", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void write_rcvd_pkt(switch_packet_seq_item t);
extern function void write_sent_pkt(switch_packet_seq_item t);

endclass: switch_scoreboard
// ----------------------------------
// Extern methods
// ----------------------------------
function switch_scoreboard::new(string name = "switch_scoreboard", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void switch_scoreboard::build_phase(uvm_phase phase);
  rcvr2sb_export = new("rcvr2sb_export", this);
  drvr2sb_export = new("drvr2sb_export", this);
  sb2coverage_ap = new("sb2coverage_ap", this);
endfunction: build_phase
//
// Write method after receiving a packet 
//
function void switch_scoreboard::write_rcvd_pkt(switch_packet_seq_item t);
  switch_packet_seq_item rcvd_pkt;
  switch_packet_seq_item expected_pkt;
  if(t == null) begin
    `uvm_error("write_rcvd_pkt", "Null object")
  end
  if(!$cast(rcvd_pkt, t.clone())) begin
    `uvm_error("write_rcvd_pkt", "Cast failed")
    return;
  end
  // If queue is not empty, start comparing
  if(packet_queue.size() == 0) begin
    `uvm_error("write_rcvd_pkt", "No packet in the packet_queue")
  end
  else begin
    expected_pkt = packet_queue.pop_front();
    if(rcvd_pkt.compare(expected_pkt)) begin
      `uvm_info("write_rcvd_pkt", "Sent packet and received packet matched", UVM_LOW)
    end
    else begin
      `uvm_error("write_rcvd_pkt", "Sent packet and received packet mismatched")
    end
  end
endfunction: write_rcvd_pkt 
//
// Write method after sending a packet
//
function void switch_scoreboard::write_sent_pkt(switch_packet_seq_item t);
  switch_packet_seq_item pkt;
  if(t == null) begin
    `uvm_error("write_rcvd_pkt", "Null object")
  end
  if(!$cast(pkt, t.clone())) begin
    `uvm_error("write_sent_pkt", "Cast failed")
    return;
  end
  packet_queue.push_back(pkt);
endfunction: write_sent_pkt

`endif // SWITCH_SCOREBOARD_SVH
