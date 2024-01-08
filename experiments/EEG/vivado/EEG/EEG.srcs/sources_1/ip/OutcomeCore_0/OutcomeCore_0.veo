// (c) Copyright 1995-2024 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

// IP VLNV: arizona.edu:user:OutcomeCore:1.0
// IP Revision: 9

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
OutcomeCore_0 your_instance_name (
  .clk(clk),                            // input wire clk
  .rst(rst),                            // input wire rst
  .tick(tick),                          // input wire tick
  .packet(packet),                      // input wire [29 : 0] packet
  .packet_valid(packet_valid),          // input wire packet_valid
  .packet_captured(packet_captured),    // output wire packet_captured
  .fifo_full(fifo_full),                // output wire fifo_full
  .outcome_error(outcome_error),        // output wire [1 : 0] outcome_error
  .m00_axis_aclk(m00_axis_aclk),        // input wire m00_axis_aclk
  .m00_axis_aresetn(m00_axis_aresetn),  // input wire m00_axis_aresetn
  .m00_axis_tvalid(m00_axis_tvalid),    // output wire m00_axis_tvalid
  .m00_axis_tdata(m00_axis_tdata),      // output wire [31 : 0] m00_axis_tdata
  .m00_axis_tstrb(m00_axis_tstrb),      // output wire [3 : 0] m00_axis_tstrb
  .m00_axis_tlast(m00_axis_tlast),      // output wire m00_axis_tlast
  .m00_axis_tready(m00_axis_tready)    // input wire m00_axis_tready
);
// INST_TAG_END ------ End INSTANTIATION Template ---------
