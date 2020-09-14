`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/14/2019 09:33:46 PM
// Design Name:
// Module Name: input_process
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


module input_process(
         input clk,
         input [27:0]data_in,
         output [27:0]data_out
       );
jitter_clr clr0(clk, data_in[0],data_out[0] );
jitter_clr clr1(clk, data_in[1],data_out[1] );
jitter_clr clr2(clk, data_in[2],data_out[2] );
jitter_clr clr3(clk, data_in[3],data_out[3] );
jitter_clr clr4(clk, data_in[4],data_out[4] );
jitter_clr clr5(clk, data_in[5],data_out[5] );
jitter_clr clr6(clk, data_in[6],data_out[6] );
jitter_clr clr7(clk, data_in[7],data_out[7] );
jitter_clr clr8(clk, data_in[8],data_out[8] );
jitter_clr clr9(clk, data_in[9],data_out[9] );
jitter_clr clr10(clk, data_in[10],data_out[10] );
jitter_clr clr11(clk, data_in[11],data_out[11] );
jitter_clr clr12(clk, data_in[12],data_out[12] );
jitter_clr clr13(clk, data_in[13],data_out[13] );
jitter_clr clr14(clk, data_in[14],data_out[14] );
jitter_clr clr15(clk, data_in[15],data_out[15] );
jitter_clr clr16(clk, data_in[16],data_out[16] );
jitter_clr clr17(clk, data_in[17],data_out[17] );
jitter_clr clr18(clk, data_in[18],data_out[18] );
jitter_clr clr19(clk, data_in[19],data_out[19] );
jitter_clr clr20(clk, data_in[20],data_out[20] );
jitter_clr clr21(clk, data_in[21],data_out[21] );
jitter_clr clr22(clk, data_in[22],data_out[22] );
jitter_clr clr23(clk, data_in[23],data_out[23] );
jitter_clr clr24(clk, data_in[24],data_out[24] );
jitter_clr clr25(clk, data_in[25],data_out[25] );
jitter_clr clr26(clk, data_in[26],data_out[26] );
jitter_clr clr27(clk, data_in[27],data_out[27] );
endmodule
