//
//  Module: Switch agent 
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
`ifndef SWITCH_AGENT_SVH
`define SWITCH_AGENT_SVH

class switch_agent extends uvm_agent;
// UVM factory registration macro
`uvm_component_utils(switch_agent)

// ---------------------------------
// Data members
// ---------------------------------
switch_agent_config m_cfg;
// ---------------------------------
// Component members
// ---------------------------------
// analysis port to send packet out for analysis
uvm_analysis_port # (switch_packet_seq_item) drvr_ap;
uvm_analysis_port # (switch_packet_seq_item) rcvr_ap;
// Other components
switch_sequencer m_sequencer;
switch_driver m_driver;
switch_receiver m_receiver[4];
switch_scoreboard m_scoreboard;
switch_coverage m_coverage;
// ---------------------------------
// Methods
// ---------------------------------
extern function new(string name = "switch_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: switch_agent
// ---------------------------------
// Extern methods
// ---------------------------------
function switch_agent::new(string name = "switch_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void switch_agent::build_phase(uvm_phase phase);
  // Build analysis port component
  drvr_ap = new("drvr_ap", this);
  rcvr_ap = new("rcvr_ap", this);
  // Retrieve configuration object
  if(!uvm_config_db # (switch_agent_config)::get(this, "", "switch_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to find switch_agent_config in uvm_config_db")
  end
  // Build receiver
  foreach(m_receiver[i]) begin
    m_receiver[i] = switch_receiver::type_id::create($sformatf("m_receiver_%0d", i), this);
  end
  // Based on is_active, build drivers, sequencer and scoreboard
  if(m_cfg.active == UVM_ACTIVE) begin
    m_sequencer = switch_sequencer::type_id::create("m_sequencer", this);
    m_driver = switch_driver::type_id::create("m_driver", this);
    m_scoreboard = switch_scoreboard::type_id::create("m_scoreboard", this);
  end
  // Enable functional coverage or not
  if(m_cfg.has_functional_coverage) begin
    m_coverage = switch_coverage::type_id::create("m_coverage", this);
  end  
endfunction: build_phase

function void switch_agent::connect_phase(uvm_phase phase);
  foreach(m_receiver[i]) begin
    m_receiver[i].output_intf = m_cfg.output_intf[i];
    m_receiver[i].rcvr2sb_ap.connect(rcvr_ap);
  end
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver.input_intf = m_cfg.input_intf;
    m_driver.mem_intf = m_cfg.mem_intf;
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    m_driver.device_addr = m_cfg.device_addr;
    m_driver.drvr2sb_ap.connect(m_scoreboard.drvr2sb_export);
    m_driver.drvr2sb_ap.connect(drvr_ap);
    // Only packets from driver have fcs_kind, so we sample here
    m_driver.drvr2sb_ap.connect(m_coverage.analysis_export);
    foreach(m_receiver[i]) begin
      m_receiver[i].rcvr2sb_ap.connect(m_scoreboard.rcvr2sb_export);
    end
  end
  if(m_cfg.has_functional_coverage) begin
    m_coverage.device_addr = m_cfg.device_addr;
  end
endfunction: connect_phase

`endif // SWITCH_AGENT_SVH

