`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/10/2019 09:49:29 PM
// Design Name:
// Module Name: character
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


module character #(parameter initial_x=64,initial_y=400,MEMFILE = "ship1.mem" )(
         input clk,
         input clk_ram,
         input RST,
         input [9:0]x,
         input [8:0]y,
         input [6:0]ctrl_bus,
         output color_on,
         output [11:0]color,
         output reg fire_on,
         output [9:0]pos_x,
         output [8:0]pos_y,
         output [4:0]rotate
       );
reg [29:0]element;
reg [15:0]addr;
reg [31:0]count;
reg fire_en;

wire pos_offset;
wire x_offset;
wire y_offset;
wire rotation_offset;

localparam character_H=32,character_W=32 ;

initial
  begin
    element[29:20]=initial_x;//x
    element[19:11]=initial_y;//y
    element[10:7]=0;//reserved
    element[6:2]=0;//rotate
    element[1:0]=0;//reserved
    fire_en=1;
    fire_on=1;
  end

assign pos_x=element[29:20];
assign pos_y=element[19:11];
assign rotate=element[6:2];

sram #(.ADDR_WIDTH(16), .DATA_WIDTH(12), .DEPTH(28672), .MEMFILE(MEMFILE)) ram(
       .i_clk(clk_ram),
       .i_addr(addr),
       .i_write(0),
       .i_data(0),
       .o_data(color)
     );

always @(posedge clk)//draw control
  begin
    if((x>=element[29:20]) & (x<(element[29:20]+character_W)) & (y>=element[19:11]) & (y<(element[19:11]+character_H)))
      begin
        addr<=(element[3:2] * 7 + element[6:4]) * 1024+(y-element[19:11])*32+x-element[29:20];
      end
    else
      addr<=16'h0000;
  end

assign color_on = (color==12'h00f) ? 0 : 1;
/*****************************************************************************************************************************/
//volcity control
reg [31:0]v_x;
reg [31:0]v_y;
always@(*)
  begin
    case(element[6:4])
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
/*****************************************************************************************************************************/
//fire control
always @(posedge clk)
  begin
    if(ctrl_bus[6] & fire_en)
      begin
        count<=32'h00000000;
        fire_en<=0;
        fire_on<=1;
      end
    else
      begin
        if(count<50000000)//
          begin
            count<=count+1;
            //fire_on<=0;
          end
        else
          begin
            count<=count;
            fire_en<=1;
          end
        fire_on<=0;
      end
  end

/*****************************************************************************************************************************/
//animate control

always @(posedge clk)
  begin
    if(element[29:20]>32 && (element[29:20]+character_W)<640-32 && (element[19:11]+character_H<480-32) && element[19:11]>32)
      begin
        case(ctrl_bus[3:0])
          4'b0001:
            begin
              case(element[3:2])
                0:
                  begin
                    element[19:11]<=element[19:11]+x_offset;
                    element[29:20]<=element[29:20]+y_offset;
                  end
                1:
                  begin
                    element[19:11]<=element[19:11]+y_offset;
                    element[29:20]<=element[29:20]-x_offset;
                  end
                2:
                  begin
                    element[19:11]<=element[19:11]-x_offset;
                    element[29:20]<=element[29:20]-y_offset;
                  end
                3:
                  begin
                    element[19:11]<=element[19:11]-y_offset;
                    element[29:20]<=element[29:20]+x_offset;
                  end
              endcase
            end
          4'b0010:
            begin
              case(element[3:2])
                0:
                  begin
                    element[19:11]<=element[19:11]-x_offset;
                    element[29:20]<=element[29:20]-y_offset;
                  end
                1:
                  begin
                    element[19:11]<=element[19:11]-y_offset;
                    element[29:20]<=element[29:20]+x_offset;
                  end
                2:
                  begin
                    element[19:11]<=element[19:11]+x_offset;
                    element[29:20]<=element[29:20]+y_offset;
                  end
                3:
                  begin
                    element[19:11]<=element[19:11]+y_offset;
                    element[29:20]<=element[29:20]-x_offset;
                  end
              endcase
            end
          4'b1000:
            begin
              case(element[3:2])
                0:
                  begin
                    element[19:11]<=element[19:11]-y_offset;
                    element[29:20]<=element[29:20]+x_offset;
                  end
                1:
                  begin
                    element[19:11]<=element[19:11]+x_offset;
                    element[29:20]<=element[29:20]+y_offset;
                  end
                2:
                  begin
                    element[19:11]<=element[19:11]+y_offset;
                    element[29:20]<=element[29:20]-x_offset;
                  end
                3:
                  begin
                    element[19:11]<=element[19:11]-x_offset;
                    element[29:20]<=element[29:20]-y_offset;
                  end
              endcase
            end
          4'b0100:
            begin
              case(element[3:2])
                0:
                  begin
                    element[19:11]<=element[19:11]+y_offset;
                    element[29:20]<=element[29:20]-x_offset;
                  end
                1:
                  begin
                    element[19:11]<=element[19:11]-x_offset;
                    element[29:20]<=element[29:20]-y_offset;
                  end
                2:
                  begin
                    element[19:11]<=element[19:11]-y_offset;
                    element[29:20]<=element[29:20]+x_offset;
                  end
                3:
                  begin
                    element[19:11]<=element[19:11]+x_offset;
                    element[29:20]<=element[29:20]+y_offset;
                  end
              endcase
            end
          default:
            begin
              element[19:11]<=element[19:11];
              element[29:20]<=element[29:20];
            end
        endcase

        if(ctrl_bus[5:4]==2'b10)
          begin
            if(element[6:4]<7)
              element[6:4]<=element[6:4]-rotation_offset;
            else
              begin
                element[3:2]<=element[3:2] - 1;
                element[6:4]<=6;
              end
          end
        else if(ctrl_bus[5:4]==2'b01)
          begin
            if(element[6:4]<7)
              element[6:4]<=element[6:4]+rotation_offset;
            else
              begin
                element[3:2]<=element[3:2] + 1;
                element[6:4]<=0;
              end
          end
        else
          begin
            element[6:2]<=element[6:2];
          end
      end
    else if(element[29:20]==32 )//prevent edge condition
      element[29:20]<=element[29:20]+1;
    else if((element[29:20]+character_W)==640-32)
      element[29:20]<=element[29:20]-1;
    else if((element[19:11]+character_H)==480-32)
      element[19:11]<=element[19:11]-1;
    else if(element[19:11]==32)
      element[19:11]<=element[19:11]+1;
    else
      begin
        element[19:11]<=element[19:11];
        element[29:20]<=element[29:20];
      end
  end
/*****************************************************************************************************************************/
wire [31:0]v_x_new;
wire [31:0]v_y_new;
assign v_x_new = v_x*5;
assign v_y_new = v_y*5;

clock clk_x_offset(
        .clk(clk),
        .rst(~(|v_x_new)),
        .rst_Target(v_x_new),
        .auto_rst(1),
        .clk_out(x_offset)
      );

clock clk_y_offset(
        .clk(clk),
        .rst(~(|v_y_new)),
        .rst_Target(v_y_new),
        .auto_rst(1),
        .clk_out(y_offset)
      );

clock clk_rotation(
        .clk(clk),
        .rst(0),
        .rst_Target(6500000),
        .auto_rst(1),
        .clk_out(rotation_offset)
      );
endmodule
