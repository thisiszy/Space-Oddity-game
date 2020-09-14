`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/12/2019 11:30:08 AM
// Design Name:
// Module Name: collision_detection
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


module collision_detection (
         input clk,
         input [27:0]color_on,//low 2 bits from user the rest from fire,higest is background
         output [2:0]damage_pulse
       );
reg [2:0]damage;

initial
  damage=3'b000;

always @(posedge clk)
  damage <= {color_on[1]&color_on[0],(|color_on[26:2])&color_on[1],(|color_on[26:2])&color_on[0]};

reg [2:0]damage_r1;
reg [2:0]damage_r2;

always @(posedge clk)
  damage_r1 <= damage;
always @(posedge clk)
  damage_r2 <= damage_r1;
assign damage_pulse = damage_r1 & (~damage_r2);
endmodule
