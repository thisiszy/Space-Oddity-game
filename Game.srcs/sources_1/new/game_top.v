`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/11/2019 06:24:17 PM
// Design Name:
// Module Name: game_top
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


module game_top(
         input wire CLK,
         input wire RST_BTN,
         input wire [3:0]BTN,
         input wire PS2_CLK,
         input wire PS2_DATA,
         input wire [15:0]SW,
         output wire VGA_HS_O,
         output wire VGA_VS_O,
         output wire [3:0] VGA_R,
         output wire [3:0] VGA_G,
         output wire [3:0] VGA_B,
         output wire [15:0]LED
       );

wire rst = RST_BTN;

wire [9:0] x;
wire [8:0] y;
wire animate;

wire clk_ram;
/************************************************************************************************************************/
//clk_gen
clk_ram ramclk
        (
          // Clock out ports
          .clk_out1(clk_ram),
          // Clock in ports
          .clk_in1(CLK)
        );
// generate a 25 MHz pixel strobe
reg [15:0] cnt = 0;
reg clk_vga = 0;
always @(posedge CLK)
  {clk_vga, cnt} <= cnt + 16'h4000;

/************************************************************************************************************************/
//input clean
wire [13:0]ctrl_bus;
wire [13:0]ctrl_bus_pre;
wire [3:0]BTNC;
reg [13:0]ctrl_bus_new;
wire [9:0]SWC;
wire start_page_done;
wire final_page_done;

input_process clr1(
                .clk(CLK),
                .data_in({SW[12:3],ctrl_bus_pre,BTN}),
                .data_out({SWC,ctrl_bus,BTNC})
              );

/******************************************************************************************************************/
//state shift
reg [2:0]state;
reg [2:0]nextstate;
wire [1:0]over;

initial
  state=3'b000;

always @(posedge CLK or posedge rst)//CLK or posedge rst)
  begin
    if(rst)
      state<=3'b000;
    else
      state<=nextstate;
  end

always @(*)
  begin
    case(state)
      3'b000:
        begin
          if(SW[15])//space(SW[15])//
            nextstate=3'b001;
          else
            nextstate=3'b000;
        end
      3'b001:
        if(start_page_done)
          nextstate=3'b010;
        else
          nextstate=3'b001;
      3'b010:
        begin
          if(over==2'b00)
            nextstate=3'b011;//both died
          else if(over==2'b01)
            nextstate=3'b100;//player 2 win
          else if(over==2'b10)
            nextstate=3'b101;//player 1 win
          else
            nextstate=3'b010;//state stage
        end
      3'b011:
        if(rst)
          nextstate=3'b000;
        else
          nextstate=3'b011;//state stage
      3'b100:
        if(final_page_done & rst)
          nextstate=3'b000;
        else
          nextstate=3'b100;//state stage
      3'b101:
        if(final_page_done & rst)
          nextstate=3'b000;
        else
          nextstate=3'b101;//state stage
      default
      nextstate=3'b000;
    endcase
  end

assign LED={over,state};
/******************************************************************************************************************/
//control select

always @(*)
  begin
    if((state==3'b000) | (state==3'b010))
      begin
        if(SW[0])
          ctrl_bus_new = {SWC,BTNC};
        else
          ctrl_bus_new = ctrl_bus;
      end
    else
      ctrl_bus_new = 14'h0000;
  end
/******************************************************************************************************************/
//display
wire active;
wire [11:0]RGB;
vga640x480 display (
             .clk(CLK),
             .clk_vga(clk_vga),
             .hs(VGA_HS_O),
             .vs(VGA_VS_O),
             .x(x),
             .y(y),
             .animate(animate),
             .active(active)
           );

game_body body(
            .CLK(CLK),
            .clk_ram(clk_ram),
            .clk_vga(clk_vga),
            .rst(rst),
            .x(x),
            .y(y),
            .animate(animate),
            .ctrl_bus_in(ctrl_bus_new),
            .state(state),
            .over(over),
            .RGB(RGB),
            .start_page_done(start_page_done),
            .final_page_done(final_page_done)
          );

assign {VGA_R,VGA_G,VGA_B} = RGB;
/************************************************************************************************************************/
//keyboard control
keyboard ctrlbus(
           .clk(PS2_CLK),  // Clock pin form keyboard
           .data(PS2_DATA), //Data pin form keyboard
           .ctrl_bus(ctrl_bus_pre) //ctrl_bus for game ctrl
         );
endmodule
