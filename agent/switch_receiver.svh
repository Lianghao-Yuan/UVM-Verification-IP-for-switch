//
//  Module: Switch receiver
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
//
//
`ifndef SWITCH_RECEIVER_SVH
`define SWITCH_RECEIVER_SVH

class switch_receiver extends uvm_component;
// UVM factory registration macro
//
`uvm_component_utils(switch_receiver)
// Virtual interface
virtual switch_output_if output_intf;
// Ananlysis port
uvm_analysis_port #(switch_packet_seq_item) rcvr2sb_ap;

// ------------------------------
// Methods
// ------------------------------
extern function new(string name = "switch_receiver", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass: switch_receiver
// ------------------------------
// Extern methods
// ------------------------------
function switch_receiver::new(string name = "switch_receiver", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void switch_receiver::build_phase(uvm_phase phase);
  rcvr2sb_ap = new("receiver2sb_ap", this);
endfunction: build_phase

task switch_receiver::run_phase(uvm_phase phase);
  switch_packet_seq_item packet;
  forever begin
    bit [7:0] bit_queue[$];
    bit [7:0] bytes[];
    // Clear queue and bytes because they are static member
    bytes.delete();
    bit_queue = {};
    // Simulate the receiving end behavior
    while(output_intf.cb.ready !== 0'b1) begin
      @(output_intf.cb);
    end;
    //@(posedge output_intf.cb.ready);
    `uvm_info("run_phase", "Begin receiving packet", UVM_LOW)
    output_intf.cb.read <= 1;
    // Wait and load data in
    repeat(2)@(output_intf.cb);
    while(output_intf.cb.ready) begin
      bit_queue.push_back(output_intf.cb.data_out);
      @(output_intf.cb);
    end
    // Send output 
    output_intf.cb.read <= 0;
    @(output_intf.cb);
    `uvm_info("run_phase", "Packet received", UVM_LOW)

    // Copy bit_queue into dynamic array 
    bytes = new[bit_queue.size()](bit_queue);
    packet = new();
    //$display("size is %d", bytes.size()); 
    // Print bytes
    //foreach(bytes[i]) begin
      //$display("%d\n", bytes[i]);
    //end
    void'(packet.unpack_bytes(bytes));
    //packet.print();
    rcvr2sb_ap.write(packet);
  end
endtask: run_phase

`endif // SWITCH_RECEIVER_SVH

