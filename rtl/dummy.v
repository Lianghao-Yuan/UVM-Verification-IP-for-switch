//
//  Module: Dummy switch to debug verification environment
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 06/25/2015
//  Copyright (C) 2015 Lianghao Yuan
//
//  Usage: change the name of this file to switch.v. Notice, this is 
//  just a simple file to test the overall connection as well as driver /
//  receiver behavior.
//
//

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
module switch(input clk,
                 input reset,
                 input data_status,
                 input [7:0] data,
                 output reg [7:0] port0,
                 output reg [7:0] port1,
                 output reg [7:0] port2,
                 output reg [7:0] port3,
                 output reg ready_0,
                 output reg ready_1,
                 output reg ready_2, 
                 output reg ready_3,
                 input read_0,
                 input read_1,
                 input read_2, 
                 input read_3,
                 input mem_en,
                 input mem_rd_wr,
                 input [1:0] mem_add, 
                 input [7:0] mem_data);

initial begin
  port0 <= 8'b0;
  port1 <= 8'b0;
  port2 <= 8'b0;
  port3 <= 8'b0;
  ready_0 <= 1'b0;
  ready_1 <= 1'b0;
  ready_2 <= 1'b0;
  ready_3 <= 1'b0;
  // Wait until reset and configuration is ready.
  repeat(100) @ (posedge clk);
  
  // Testing first output port
  ready_0 <= 1'b1;
  @ (posedge clk);
  @ (posedge clk);
  // Send SA, DA
  port0 <= 8'b1;
  repeat(2) @ (posedge clk);
  // Length = 1
  port0 <= 8'b1;
  @ (posedge clk);
  // Data = 1
  port0 <= 8'b1;
  @ (posedge clk);
  // FCS = 1
  port0 <= 8'b1;
  @ (posedge clk);
  ready_0 <= 1'b0;
end


endmodule

