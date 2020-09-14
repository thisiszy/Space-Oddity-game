`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/20/2019 12:57:12 PM
// Design Name:
// Module Name: final_page_2
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


module final_page_2(
         input clk,
         input clk_ram,
         input [9:0]x,
         input [8:0]y,
         input [2:0]state,
         output color_on,
         output [11:0]color
       );
reg [15:0]addr;

sram #(.ADDR_WIDTH(16), .DATA_WIDTH(12), .DEPTH(14595), .MEMFILE("final_page_2.mem")) background(
       .i_clk(clk_ram),
       .i_addr(addr),
       .i_write(0),
       .i_data(0),
       .o_data(color)
     );

always @(posedge clk)
  begin
    if((x>=111) & (x<528) &(y>=222) & (y<257) & (state==3'b011))
      addr<=x-111 + (y-222)*417;
    else
      addr<=16'h0000;
  end

assign color_on = (color == 12'h00f) ? 0 : 1;

endmodule
