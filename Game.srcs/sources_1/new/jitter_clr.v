`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/12/2019 02:00:18 PM
// Design Name:
// Module Name: jitter_clr
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


module jitter_clr(clk, button,button_clean );
input clk;
input button;
output button_clean;
reg [19:0] cnt;

always @(posedge clk)
  begin
    if(button==1'b0)
      cnt <= 20'h00000;
    else if(cnt<20'h80000)
      cnt <= cnt + 1'b1;
  end
assign button_clean = cnt[19];
endmodule

