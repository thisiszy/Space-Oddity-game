`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/11/2019 10:45:36 AM
// Design Name:
// Module Name: top_for_ps2
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


module top_for_ps2(
         //         input CLK,
         //         input RST_BTN,
         //         output wire VGA_HS_O,       // horizontal sync output
         //         output wire VGA_VS_O,       // vertical sync output
         //         output wire [3:0] VGA_R,    // 4-bit VGA red output
         //         output wire [3:0] VGA_G,    // 4-bit VGA green output
         //         output wire [3:0] VGA_B     // 4-bit VGA blue output
         input UART_TXD_IN,
         output UART_RXD_OUT
       );
assign UART_RXD_OUT=UART_TXD_IN;
//wire clk_ram;
//wire rst = RST_BTN;  // reset is active high on Basys3 (BTNC)

//wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
//wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
//clk_ram clk_new(
//          // Clock out ports
//          .clk_out1(clk_ram),
//          // Clock in ports
//          .clk_in1(CLK)
//        );
//// generate a 25 MHz pixel strobe
//reg [15:0] cnt = 0;
//reg pix_stb = 0;
//always @(posedge CLK)
//  {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

//wire [12:0]addr;
//wire [11:0]color;
//wire active;
//vga640x480 display (
//             .i_clk(CLK),
//             .i_pix_stb(pix_stb),
//             .i_rst(rst),
//             .o_hs(VGA_HS_O),
//             .o_vs(VGA_VS_O),
//             .o_x(x),
//             .o_y(y),
//             .o_active(active)
//           );


//sram #(.ADDR_WIDTH(13), .DATA_WIDTH(12), .DEPTH(8192), .MEMFILE("vga03_sprites.mem")) ram(
//       .i_clk(clk_ram),
//       .i_addr(addr),
//       .i_write(0),
//       .i_data(0),
//       .o_data(color)
//     );

//wire sq_a;
////assign address = y * 640 + x;
//assign sq_a = ((x > 120) & (y >  40) & (x < 376) & (y < 72)) ? 1 : 0;
//assign addr = sq_a ? ((y-40)*256+x-120) : 16'h0000;
//assign {VGA_R,VGA_G,VGA_B} = (color==12'h00f) ? 4'h0 : color;
endmodule
