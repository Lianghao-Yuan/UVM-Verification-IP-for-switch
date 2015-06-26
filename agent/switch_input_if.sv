//
//  Module: Switch input interface
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
`ifndef SWITCH_INPUT_IF_SV
`define SWITCH_INPUT_IF_SV

interface switch_input_if #(parameter setup_time = 5ns,
                            parameter hold_time  = 3ns)
                           // Input / output 
                           (input bit clock);

logic       data_status;
logic [7:0] data_in;
logic reset;

clocking cb@(posedge clock);
  default input #setup_time output #hold_time;
  output data_status;
  output data_in;
endclocking: cb

endinterface: switch_input_if

`endif // SWITCH_INPUT_IF_SV

