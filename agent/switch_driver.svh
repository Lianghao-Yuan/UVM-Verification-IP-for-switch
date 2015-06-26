//
//  Module: Switch driver
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
`ifndef SWITCH_DRIVER_SVH
`define SWITCH_DRIVER_SVH

class switch_driver extends uvm_driver # (switch_packet_seq_item);

// UVM factory registration macros
//
`uvm_component_utils(switch_driver)

// Virtual interfaces
virtual switch_input_if input_intf;
virtual switch_mem_if   mem_intf;

// ----------------------
// Data members
// ----------------------
bit [7:0] device_addr[4];

// Analysis port: driver to scoreboard
uvm_analysis_port #(switch_packet_seq_item) drvr2sb_ap;

// ----------------------
// Methods
// ----------------------
extern function new(string name = "switch_driver", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task reset_dut();
extern task cfg_dut();
extern task drive(switch_packet_seq_item pkt);

endclass: switch_driver

function switch_driver::new(string name = "switch_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction: new
// ------------------------
// Extern methods
// ------------------------

function void switch_driver::build_phase(uvm_phase phase);
  drvr2sb_ap = new("drvr2sb_ap", this);
endfunction: build_phase

//
// Run_phase: reset, configure DUT, then drive whatever packet coming
//
task switch_driver::run_phase(uvm_phase phase);
  switch_packet_seq_item req;
  // Reset DUT
  reset_dut();
  // Configure DUT
  cfg_dut();
  // Drive whatever sequence coming
  @(input_intf.cb);
  forever begin: drive_seq_item
    seq_item_port.get_next_item(req);
    // Send through analysis port
    drvr2sb_ap.write(req);
    drive(req);
    seq_item_port.item_done();
  end: drive_seq_item
endtask: run_phase

//
// Reset DUT: providing reset signal for switch
//
task switch_driver::reset_dut();
  `uvm_info("reset_dut", "Start reset_dut() method", UVM_LOW)

  mem_intf.mem_data <= 0;
  mem_intf.mem_add <= 0;
  mem_intf.mem_en <= 0;
  mem_intf.mem_rd_wr <= 0;
  input_intf.data_in <= 0;
  input_intf.data_status <= 0;
  // Reset the switch
  input_intf.reset <= 1;
  repeat(4)@input_intf.cb;
  input_intf.reset <= 0;

  `uvm_info("reset_dut", "End of reset_dut() method", UVM_LOW)
endtask: reset_dut

//
// Configure DUT: configure the address of four ports
//
task switch_driver::cfg_dut();
  `uvm_info("cfg_dut", "Start cfg_dut() method", UVM_LOW)
  @(mem_intf.cb);
  mem_intf.mem_en <= 1;
  @(mem_intf.cb);
  // Configure four port addresses
  foreach(device_addr[i]) begin
    mem_intf.mem_rd_wr <= 1;
    mem_intf.mem_add <= i;
    mem_intf.mem_data <= device_addr[i];

    @(mem_intf.cb);
    mem_intf.mem_rd_wr <= 0;
    @(mem_intf.cb);
  end
  // Reset all memory related signals to 0
  mem_intf.mem_data <= 0;
  mem_intf.mem_add <= 0;
  mem_intf.mem_en <= 0;
  mem_intf.mem_rd_wr <= 0;
  @(mem_intf.cb);
endtask: cfg_dut

//
// Drive a packet into switch
//
task switch_driver::drive(switch_packet_seq_item pkt);
  // Pack packets into byte stream
  byte unsigned bytes[];
  bytes.delete();
  void'(pkt.pack_bytes(bytes));

  foreach(bytes[i]) begin
    @(input_intf.cb);
    input_intf.data_status <= 1;
    input_intf.data_in <= bytes[i];
  end
  // Reset all input signal to 0
  @(input_intf.cb);
  input_intf.data_status <= 0;
  input_intf.data_in <= 0;
  // To ensure at least 3 clock cycles between packet transmission
  repeat(3)@(input_intf.cb);
endtask: drive

`endif //SWITCH_DRIVER_SVH

