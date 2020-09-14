`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/15/2019 12:14:19 AM
// Design Name:
// Module Name: pulse
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module pulse(
         input clk,
         input button,
         output button_redge
       );
reg button_r1,button_r2;

always @(posedge clk)
  button_r1 <= button;
always @(posedge clk)
  button_r2 <= button_r1;
assign button_redge = button_r1 & (~button_r2);

endmodule
