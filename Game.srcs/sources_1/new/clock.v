`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/11/2019 05:00:21 PM
// Design Name:
// Module Name: clock
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


module clock (
         input clk,
         input rst,
         input [31:0]rst_Target,
         input auto_rst,
         output reg clk_out,
         output reg [31:0]counter
       );
//reg [31:0]counter;
//assign test=counter;


always @(posedge clk or posedge rst)
  begin
    if(rst)
      begin
        counter<=rst_Target;
        clk_out<=0;
      end
    else
      begin
        if(counter>0)
          begin
            counter<=counter-1;
            clk_out<=0;
          end
        else
          begin
            if(auto_rst)
              counter<=rst_Target;
            else
              counter<=counter;
            clk_out<=1;
          end
      end
  end
endmodule
