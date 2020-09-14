`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/19/2019 10:54:38 PM
// Design Name:
// Module Name: final_page
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


module final_page(
         input clk,
         input clk_ram,
         input rst,
         input [9:0]x,
         input [8:0]y,
         input [9:0]x_1,
         input [8:0]y_1,
         input [9:0]x_2,
         input [8:0]y_2,
         input [1:0]over,
         input [2:0]state,
         input pulse,//1 tick per screen
         output reg color_on,
         output [11:0]color,
         output reg done
       );
wire setpos;
reg flag;
reg [9:0]black_x_l;
reg [8:0]black_y_u;
reg [9:0]black_x_r;
reg [8:0]black_y_d;
reg [9:0]pos_x;
reg [8:0]pos_y;
initial
  begin
    flag=0;
    done=0;
  end

always@(posedge clk)
  begin
    flag<=((state==3'b101) | (state==3'b100));
    done<=((black_x_l == (pos_x-10)) & (black_x_r == (pos_x +42)) & (black_y_u == (pos_y - 10)) & (black_y_d == (pos_y + 42)));
  end

always@(posedge setpos)
  begin
    pos_x<= (over==2'b01)? x_2:x_1;
    pos_y<= (over==2'b01)? y_2:y_1;
  end

always @(posedge clk_ram)
  begin
    if((x<black_x_l) | (y>black_y_d) | (x>black_x_r) | (y <black_y_u))
      color_on<=1;
    else
      color_on<=0;
  end

assign color = 12'h000;

always @(posedge clk or posedge rst)
  begin
    if(setpos | rst)
      begin
        black_x_l<=32;
        black_x_r<=608;
        black_y_u<=32;
        black_y_d<=448;
      end
    else if(pulse & ((state==3'b101) | (state==3'b100)))
      begin
        if(black_x_l < (pos_x-10))
          begin
            black_x_l<=black_x_l + 1;
          end
        else
          begin
            black_x_l<=black_x_l;
          end

        if(black_x_r > (pos_x +42))
          begin
            black_x_r<=black_x_r - 1;
          end
        else
          begin
            black_x_r<=black_x_r;
          end

        if(black_y_u < (pos_y - 10))
          begin
            black_y_u<=black_y_u + 1;
          end
        else
          begin
            black_y_u<=black_y_u;
          end

        if(black_y_d > (pos_y + 42))
          begin
            black_y_d<=black_y_d - 1;
          end
        else
          begin
            black_y_d<=black_y_d;
          end
      end
    else
      ;
  end

reg flag_r1;
reg flag_r2;
always @(posedge clk)
  flag_r1 <= flag;
always @(posedge clk)
  flag_r2 <= flag_r1;
assign setpos = flag_r1 & (~flag_r2);
endmodule
