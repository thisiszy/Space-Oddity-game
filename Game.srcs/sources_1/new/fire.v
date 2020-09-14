`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/12/2019 05:28:35 PM
// Design Name:
// Module Name: fire
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


module fire #(parameter initial_x=1,initial_y=1,type=0)(
         input clk,
         input rst,
         input clk_ram,
         input [9:0]x,
         input [8:0]y,
         input [9:0]pos_x,
         input [8:0]pos_y,
         input [4:0]rotation,
         input en,
         input direction,
         output color_on,
         output [11:0]color,
         output reg ready
       );
localparam character_W = 32,character_H = 32;
reg [29:0]element;
reg [12:0]addr;
reg [22:0]v_x;
reg [22:0]v_y;
wire v_x_add;
wire v_y_add;
wire visible;


initial
  begin
    element=0;
  end

always@(*)
  begin
    case(element[10:8])
      0:
        begin
          v_y=100000;
          v_x=0;
        end
      1:
        begin
          v_y=102571;
          v_x=449395;
        end
      2:
        begin
          v_y=110991;
          v_x=230476;
        end
      3:
        begin
          v_y=127904;
          v_x=160387;
        end
      4:
        begin
          v_y=160387;
          v_x=127904;
        end
      5:
        begin
          v_y=230476;
          v_x=110991;
        end
      6:
        begin
          v_y=449395;
          v_x=102571;
        end
      7:
        begin
          v_y=0;
          v_x=100000;
        end
      default
      begin
        v_y=0;
        v_x=0;
      end
    endcase
  end

sram #(.ADDR_WIDTH(13), .DATA_WIDTH(12), .DEPTH(8192), .MEMFILE("vga03_sprites.mem")) ram(
       .i_clk(clk_ram),
       .i_addr(addr),
       .i_write(0),
       .i_data(0),
       .o_data(color)
     );

always @(posedge clk)//draw control
  begin
    if((x>=element[29:20]) & (x<=(element[29:20]+character_W-1)) & (y>=element[19:11]) & (y<=(element[19:11]+character_H)) & en & visible)
      begin
        addr<=160+(y-element[19:11])*256+x-element[29:20] + 32*type;
      end
    else
      addr<=16'h0000;
  end

wire setpos;

always @(posedge clk)// or posedge setpos)
  begin
    if(setpos)
      begin
        element[29:20]<=pos_x;
        element[19:11]<=pos_y;
        element[10:6]<=rotation;
        ready<=0;
      end
    else
      begin
        if((element[29:20]>0) & ((element[29:20]+character_W)<640) & ((element[19:11]+character_H)<480) & (element[19:11]>0))
          begin
            case(element[7:6])
              2'b00:
                begin
                  element[29:20]<=element[29:20]+v_x_add;
                  element[19:11]<=element[19:11]-v_y_add;
                end
              2'b01:
                begin
                  element[29:20]<=element[29:20]+v_y_add;
                  element[19:11]<=element[19:11]+v_x_add;
                end
              2'b10:
                begin
                  element[29:20]<=element[29:20]-v_x_add;
                  element[19:11]<=element[19:11]+v_y_add;
                end
              2'b11:
                begin
                  element[29:20]<=element[29:20]-v_y_add;
                  element[19:11]<=element[19:11]-v_x_add;
                end
            endcase
          end
        else
          begin
            element[29:20]<=element[29:20];
            element[19:11]<=element[19:11];
            ready<=1;
          end
      end
  end

assign color_on= ((color==12'h00f)) ? 0 : 1;// & (~en)

pulse_reverse #(.netnum(1)) pulsere(
                .clk(clk),
                .in(rst),
                .out(setpos)//one tick high signal
              );

wire [23:0]v_x_new;
wire [23:0]v_y_new;
wire [23:0]visible_rst;
assign visible_rst = direction ? 6000000 : 4000000;
assign v_x_new = {v_x,1'b0};
assign v_y_new = {v_y,1'b0};

clock anim_x(
        .clk(clk),
        .rst(~(|v_x_new)),
        .rst_Target(v_x_new),
        .auto_rst(1),
        .clk_out(v_x_add)
      );

clock anim_y(
        .clk(clk),
        .rst(~(|v_y_new)),
        .rst_Target(v_y_new),
        .auto_rst(1),
        .clk_out(v_y_add)
      );

clock visi(
        .clk(clk),
        .rst(setpos),
        .rst_Target(visible_rst),
        .auto_rst(0),
        .clk_out(visible)
      );
endmodule
