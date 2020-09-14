`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/12/2019 11:57:54 PM
// Design Name:
// Module Name: meteorolite
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


module meteorolite #(parameter initial_x=0,initial_y=0,seed = 12345678)(
         input clk,
         input clk_ram,
         input [9:0]x,
         input [8:0]y,
         input en,
         input meteorolite_type,
         output color_on,
         output [11:0]color
       );
localparam character_W = 32,character_H = 32;
reg [29:0]element;
reg [12:0]addr;
reg [9:0]v_x;
reg [9:0]v_y;
wire v_x_add;
wire v_y_add;

initial
  begin
    element[29:20]=initial_x;//x
    element[19:11]=initial_y;//y
    element[10:7]=0;//rotation
    element[6:5]=0;//direction
    element[4:0]=0;//reserved
  end

always@(*)
  begin
    case(element[10:7])
      0:
        begin
          v_x=100000;
          v_y=10000000;
        end
      1:
        begin
          v_x=102571;
          v_y=449395;
        end
      2:
        begin
          v_x=110991;
          v_y=230476;
        end
      3:
        begin
          v_x=127904;
          v_y=160387;
        end
      4:
        begin
          v_x=160387;
          v_y=127904;
        end
      5:
        begin
          v_x=230476;
          v_y=110991;
        end
      6:
        begin
          v_x=449395;
          v_y=102571;
        end
      7:
        begin
          v_x=10000000;
          v_y=100000;
        end
      default
      begin
        v_x=0;
        v_y=0;
      end
    endcase
  end

sram #(.ADDR_WIDTH(13), .DATA_WIDTH(12), .DEPTH(8192), .MEMFILE("meteorolite.mem")) ram(
       .i_clk(clk_ram),
       .i_addr(addr),
       .i_write(0),
       .i_data(0),
       .o_data(color)
     );

reg [1:0]animation;

always @(posedge clk)//draw control
  begin
    if((x>=element[29:20]) & (x<(element[29:20]+character_W)) & (y>=element[19:11]) & (y<(element[19:11]+character_H)) & en)//这里en也许有问�?
      begin
        addr<=meteorolite_type * 4096+(y-element[19:11])*32+x-element[29:20]+animation * 1024;
      end
    else
      addr<=16'h0000;
  end

wire animation_ctrl;

always @(posedge animation_ctrl)
  begin
    animation<=animation+1;
  end


assign color_on = (color==12'h00f) ? 0 : 1;

wire [9:0]random_x;
wire [8:0]random_y;

wire [23:0]v_x_new;
wire [23:0]v_y_new;
wire [24:0]random_main;
wire [9:0]random_x_new;
wire [8:0]random_y_new;

always @(posedge clk)//random position
  begin
    if((element[29:20]>0) & ((element[29:20]+character_W)<640) & ((element[19:11]+character_H)<480) & (element[19:11]>0) & en)//有en的地方�?�会出问�?
      begin
        if(element[6:5]==2'b00)
          begin
            element[29:20]<=element[29:20]+v_x_add;
            element[19:11]<=element[19:11]+v_y_add;
          end
        else if(element[6:5]==2'b01)
          begin
            element[29:20]<=element[29:20]-v_x_add;
            element[19:11]<=element[19:11]-v_y_add;
          end
        else if(element[6:5]==2'b10)
          begin
            element[29:20]<=element[29:20]-v_x_add;
            element[19:11]<=element[19:11]+v_y_add;
          end
        else
          begin
            element[29:20]<=element[29:20]+v_x_add;
            element[19:11]<=element[19:11]-v_y_add;
          end
      end
    else
      begin
        if(random_x[1:0]==2'b00)
          begin
            element[29:20]<=1;
            element[19:11]<=random_y+40;
            element[6:5]<={2{random_y[0]}};
          end
        else if(random_x[1:0]==2'b10)
          begin
            element[29:20]<=random_x+80;
            element[19:11]<=1;
            element[6:5]<={random_y[0],1'b0};
          end
        else if(random_x[1:0]==2'b01)
          begin
            element[29:20]<=random_x+80;
            element[19:11]<=480-character_H-1;
            element[6:5]<={random_y[0],1'b1};
          end
        else
          begin
            element[29:20]<=640-character_W-1;
            element[19:11]<=random_y+40;
            element[6:5]<={~random_y[0],random_y[0]};
          end
        element[10:7]<=random_main[2:0];
      end
  end

assign v_x_new = v_x*4000;
assign v_y_new = v_y*4000;
assign random_x_new = random_main[9:0] & 500;
assign random_y_new = random_main[12:4] & 380;

clock clk1(
        .clk(clk),
        .rst(0),
        .rst_Target(v_x_new),
        .auto_rst(1),
        .clk_out(v_y_add)
      );
clock clk2(
        .clk(clk),
        .rst(0),
        .rst_Target(v_y_new),
        .auto_rst(1),
        .clk_out(v_x_add)
      );

clock random_clk_y(
        .clk(clk),
        .rst(0),
        .rst_Target(random_y_new),
        .auto_rst(1),
        .counter(random_y)
      );

clock random_clk_x(
        .clk(clk),
        .rst(0),
        .rst_Target(random_x_new),
        .auto_rst(1),
        .counter(random_x)
      );

clock random_clk_main(
        .clk(clk),
        .rst(0),
        .rst_Target(seed),
        .auto_rst(1),
        .counter(random_main)
      );

clock anim(
        .clk(clk),
        .rst(0),
        .rst_Target(50000000),
        .auto_rst(1),
        .clk_out(animation_ctrl)
      );
endmodule
