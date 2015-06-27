//
//  Module: Switch testbench
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
`ifndef SWITCH_TB_SV
`define SWITCH_TB_SV

module switch_tb;

import uvm_pkg::*;
import switch_test_pkg::*;

bit clock;

// Generate clock signal
initial begin
  clock = 0;
  forever #10 clock = ~clock;
end

// interface instantiation
switch_mem_if    mem_intf(clock);
switch_input_if  input_intf(clock);
switch_output_if output_intf[4](clock);

// Connect the DUT wrapper
switch_wrapper dut_wrapper(.clock(clock),
                           .input_intf,
                           .output_intf,
                           .mem_intf);

initial begin
  uvm_config_db # (virtual switch_mem_if)::set(null, "uvm_test_top", "mem_intf", mem_intf);
  uvm_config_db # (virtual switch_input_if)::set(null, "uvm_test_top", "input_intf", input_intf);
  uvm_config_db # (virtual switch_output_if)::set(null, "uvm_test_top", "output_intf_0", output_intf[0]);
  uvm_config_db # (virtual switch_output_if)::set(null, "uvm_test_top", "output_intf_1", output_intf[1]);
  uvm_config_db # (virtual switch_output_if)::set(null, "uvm_test_top", "output_intf_2", output_intf[2]);
  uvm_config_db # (virtual switch_output_if)::set(null, "uvm_test_top", "output_intf_3", output_intf[3]); 

  run_test();
end

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0, switch_tb);
end

endmodule: switch_tb

`endif // SWITCH_TB_SV

