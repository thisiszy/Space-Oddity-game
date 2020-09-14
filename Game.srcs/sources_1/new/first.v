`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/13/2019 04:41:57 PM
// Design Name:
// Module Name: first
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


module start_page(
         input clk,
         input clk_ram,
         input rst,
         input [9:0]x,
         input [8:0]y,
         input [9:0]x_1,
         input [8:0]y_1,
         input [4:0]rotate_1,
         input [9:0]x_2,
         input [8:0]y_2,
         input [4:0]rotate_2,
         input [2:0]state,
         output color_on,
         output [11:0]color,
         output reg [13:0]sys_ctrl,
         output reg done
       );
reg [15:0]addr;
localparam xpos_1=140,ypos_1=240,xpos_2=480,ypos_2=240;


sram #(.ADDR_WIDTH(16), .DATA_WIDTH(12), .DEPTH(57280), .MEMFILE("start_page.mem")) start(
       .i_clk(clk_ram),
       .i_addr(addr),
       .i_write(0),
       .i_data(0),
       .o_data(color)
     );

always @(posedge clk)
  begin
    if((state==3'b000 | state==3'b001) & (x>=160) & (x<480) & (y>=150) &(y<329))
      begin
        addr<=320*(y-150)+x-160;
      end
    else
      addr<=16'h0000;
  end

assign color_on = (color==12'h00f) ? 0 : 1;
always @(posedge clk)
  done <= ((x_1==xpos_1) & (y_1==ypos_1) & (x_2==xpos_2) & (y_2==ypos_2) & (rotate_2==5'b00011) & (rotate_1==5'b00001));

initial
  begin
    sys_ctrl=14'h00000;
    done=1'b0;
  end

reg state_shift;
reg nextstate;
initial
  state_shift=1'b0;

always @(posedge clk or posedge rst)
  begin
    if(rst)
      state_shift<=1'b0;
    else
      state_shift<=nextstate;
  end

always @(*)
  begin
    if((state_shift==1'b0) & (x_1==xpos_1) & (y_1==ypos_1) & (x_2==xpos_2) & (y_2==ypos_2))
      nextstate=1'b1;
    else
      nextstate=state_shift;
  end

always @(posedge clk)
  begin
    if(state_shift==0)
      begin
        if(x_1<xpos_1)
          begin
            if(rotate_1!=5'b00001)
              begin
                sys_ctrl[5]<=1;
                sys_ctrl[3]<=0;
              end
            else
              begin
                sys_ctrl[5]<=0;
                sys_ctrl[3]<=1;
              end
          end
        else if(x_1>xpos_1)
          begin
            if(rotate_1!=5'b00011)
              begin
                sys_ctrl[5]<=1;
                sys_ctrl[3]<=0;
              end
            else
              begin
                sys_ctrl[5]<=0;
                sys_ctrl[3]<=1;
              end
          end
        else if(y_1<ypos_1)
          begin
            if(rotate_1!=5'b00010)
              begin
                sys_ctrl[5]<=1;
                sys_ctrl[3]<=0;
              end
            else
              begin
                sys_ctrl[5]<=0;
                sys_ctrl[3]<=1;
              end
          end
        else if(y_1>ypos_1)
          begin
            if(rotate_1!=5'b00000)
              begin
                sys_ctrl[5]<=1;
                sys_ctrl[3]<=0;
              end
            else
              begin
                sys_ctrl[5]<=0;
                sys_ctrl[3]<=1;
              end
          end
        else
          begin
            sys_ctrl[5]<=0;
            sys_ctrl[3]<=0;
          end

        if(x_2<xpos_2)
          begin
            if(rotate_2!=5'b00001)
              begin
                sys_ctrl[12]<=1;
                sys_ctrl[10]<=0;
              end
            else
              begin
                sys_ctrl[12]<=0;
                sys_ctrl[10]<=1;
              end
          end
        else if(x_2>xpos_2)
          begin
            if(rotate_2!=5'b00011)
              begin
                sys_ctrl[12]<=1;
                sys_ctrl[10]<=0;
              end
            else
              begin
                sys_ctrl[12]<=0;
                sys_ctrl[10]<=1;
              end
          end
        else if(y_2<ypos_2)
          begin
            if(rotate_2!=5'b00010)
              begin
                sys_ctrl[12]<=1;
                sys_ctrl[10]<=0;
              end
            else
              begin
                sys_ctrl[12]<=0;
                sys_ctrl[10]<=1;
              end
          end
        else if(y_2>ypos_2)
          begin
            if(rotate_2!=5'b00000)
              begin
                sys_ctrl[12]<=1;
                sys_ctrl[10]<=0;
              end
            else
              begin
                sys_ctrl[12]<=0;
                sys_ctrl[10]<=1;
              end
          end
        else
          begin
            sys_ctrl[12]<=0;
            sys_ctrl[10]<=0;
          end
      end
    else
      begin
        if(rotate_2!=5'b00011)
          sys_ctrl[12]<=1;
        else
          sys_ctrl[12]<=0;

        if(rotate_1!=5'b00001)
          sys_ctrl[5]<=1;
        else
          sys_ctrl[5]<=0;

        sys_ctrl[10]<=0;
        sys_ctrl[3]<=0;
      end
  end
endmodule
