//
//  Module: Switch packet sequence item
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 06/21/2015
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
`ifndef SWITCH_PACKET_SEQ_ITEM_SVH
`define SWITCH_PACKET_SEQ_ITEM_SVH

class switch_packet_seq_item extends uvm_sequence_item;

// UVM factory registration macro
//
`uvm_object_utils(switch_packet_seq_item)

// ---------------------------
// Data members
// ---------------------------
rand fcs_kind_t fcs_kind;

rand bit [7:0] da;
rand bit [7:0] sa;
rand bit [7:0] length;
rand bit [7:0] data[];
rand bit [7:0] fcs;
// ---------------------------
// Constraints
// ---------------------------
//
// Data length
constraint length_c {
  solve data.size before length;
  length == data.size;
}

constraint da_c {
  da >= 0;
  da <= 3;
}
// ---------------------------
// Methods
// ---------------------------
extern function new(string name = "switch_packet_seq_item");
extern function void post_randomize();
extern function byte calculate_fcs();
extern function void do_copy(uvm_object rhs);
extern function void do_pack(uvm_packer packer);
extern function void do_unpack(uvm_packer packer);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();
extern function void do_print(uvm_printer printer);

endclass: switch_packet_seq_item
// -------------------------------
// Extern methods
// -------------------------------

function switch_packet_seq_item::new(string name = "switch_packet_seq_item");
  super.new(name);
endfunction: new

// Assign fcs in post_randomize()
//
function void switch_packet_seq_item::post_randomize();
  if(fcs_kind == GOOD_FCS) begin
    fcs = 8'b0;
  end
  else begin
    fcs = 8'b1;
  end
  // assign fcs
  fcs = calculate_fcs();
endfunction: post_randomize

//
// Calculate fcs
//
function byte switch_packet_seq_item::calculate_fcs();
  return da ^ sa ^ length ^ data.xor() ^ fcs;
endfunction: calculate_fcs
//
// Manually do_copy
//
function void switch_packet_seq_item::do_copy(uvm_object rhs);
  switch_packet_seq_item rhs_;
  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "Cast failed")
    return;
  end

  super.do_copy(rhs);
  da = rhs_.da;
  sa = rhs_.sa;
  length = rhs_.length;
  data = new[length];
  foreach(data[i]) begin
    data[i] = rhs_.data[i];
  end
  fcs = rhs_.fcs;
  fcs_kind = rhs_.fcs_kind;

endfunction: do_copy
 
//
// Manually do_pack
//
function void switch_packet_seq_item::do_pack(uvm_packer packer);
  super.do_pack(packer);
  // Pack DA, SA, length
  packer.pack_field_int(da, $bits(da));
  packer.pack_field_int(sa, $bits(sa));
  packer.pack_field_int(length, $bits(length));
  // Pack data
  foreach(data[i]) begin
    packer.pack_field_int(data[i], 8);
  end
  // Pack fcs
  packer.pack_field_int(fcs, $bits(fcs));
endfunction: do_pack

//
// Manually do_unpack
//
function void switch_packet_seq_item::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  // Unpack DA, SA, length
  da = packer.unpack_field_int($bits(da));
  sa = packer.unpack_field_int($bits(sa));
  length = packer.unpack_field_int($bits(length));
  // Unpack data
  data.delete();
  data = new[length];
  foreach(data[i]) begin
    data[i] = packer.unpack_field_int(8);
  end
  // Unpack fcs
  fcs = packer.unpack_field_int($bits(fcs));
endfunction: do_unpack

//
// Manually do_compare
//
function bit switch_packet_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  // Cast back to packet
  switch_packet_seq_item rhs_;
  // Declaration can only be made at beginning of function
  bit data_equal;

  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_compare", "cast of rhs object failed")
    return 0;
  end

   // Compare data
  //bit data_equal;
  data_equal = 1;
  foreach(data[i]) begin
    if(data[i] != rhs_.data[i]) begin
      data_equal = 0;
    end
  end

  return super.do_compare(rhs_, comparer) &&
         (da == rhs_.da) &&
         (sa == rhs_.sa) &&
         (length == rhs_.length) &&
         (data_equal) &&
         (fcs == rhs_.fcs);
endfunction: do_compare

//
// Manually convert2string
//
function string switch_packet_seq_item::convert2string();
  string s;

  $sformat(s, "%s\n", super.convert2string());
  // Convert2string function reusing string s
  $sformat(s, "%s\n Hexadecimal output\n DA = %0h\n SA = %0h Length = %0h", s, da, sa, length);
  foreach(data[i]) begin
    $sformat(s, "%s\n Data[%0d] = %0h", s, i, data[i]);
  end
  $sformat(s, "%s\n FCS = %0h\n FCS_kind = %s", s, fcs, fcs_kind.name());
endfunction: convert2string

//
// Manually do_print
//
function void switch_packet_seq_item::do_print(uvm_printer printer);
  if(printer.knobs.sprint == 0) begin
    $display(convert2string());
  end
  else begin
    printer.m_string = convert2string();
  end
endfunction: do_print

`endif // SWITCH_PACKET_SEQ_ITEM_SVH


