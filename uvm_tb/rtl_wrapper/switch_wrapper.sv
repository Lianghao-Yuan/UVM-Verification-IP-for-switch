//
//  Module: Switch wrapper
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 06/24/2015
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

`ifndef SWITCH_WRAPPER_SV
`define SWITCH_WRAPPER_SV

module switch_wrapper (switch_input_if input_intf,
                       switch_output_if output_intf[4],
                       switch_mem_if mem_intf,
                       input clock);

switch DUT (.clk(clock),
            // Input interface   
            .reset(input_intf.reset),
            .data_status(input_intf.data_status),
            .data(input_intf.data_in),
            // Output interfaces
            .port0(output_intf[0].data_out),
            .port1(output_intf[1].data_out),
            .port2(output_intf[2].data_out),
            .port3(output_intf[3].data_out),
            .ready_0(output_intf[0].ready),
            .ready_1(output_intf[1].ready),
            .ready_2(output_intf[2].ready),
            .ready_3(output_intf[3].ready),
            .read_0(output_intf[0].read),
            .read_1(output_intf[1].read),
            .read_2(output_intf[2].read),
            .read_3(output_intf[3].read),
            // Memory interface
            .mem_en(mem_intf.mem_en),
            .mem_rd_wr(mem_intf.mem_rd_wr),
            .mem_add(mem_intf.mem_add),
            .mem_data(mem_intf.mem_data));


  
endmodule: switch_wrapper

`endif // SWITCH_WRAPPER_SV
