`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/18/2019 06:32:10 PM
// Design Name:
// Module Name: pulse_reverse
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


module pulse_reverse#(parameter netnum=10)(
         input clk,
         input [netnum-1:0]in,
         output [netnum-1:0]out
       );
reg [netnum-1:0]in_r1;
reg [netnum-1:0]in_r2;

always@(posedge clk)
  begin
    in_r1<=in;
    in_r2<=in_r1;
  end
assign out=in_r2^in;
endmodule
