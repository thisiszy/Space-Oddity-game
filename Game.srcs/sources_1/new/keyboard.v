`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/11/2019 10:09:04 AM
// Design Name:
// Module Name: keyboard
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


module keyboard(
         input wire clk,
         input wire data,
         output [13:0] ctrl_bus //ctrl_bus for game ctrl
       );
reg [7:0] data_curr;
reg [7:0] data_pre;
reg keyW;
reg keyA;
reg keyS;
reg keyD;
reg keyQ;
reg keyE;
reg keySp;
reg keyI;
reg keyJ;
reg keyK;
reg keyL;
reg keyU;
reg keyO;
reg keyP;
reg [7:0] key_correct;
reg [3:0] b;
reg flag;
parameter W = 8'h1d,A = 8'h1c,S = 8'h1b,D = 8'h23,Space = 8'h29,I = 8'h43,J = 8'h3b,K = 8'h42,L = 8'h4b,P = 8'h4d, Q = 8'h15,E = 8'h24,U = 8'h3c,O = 8'h44;
initial
  begin
    b=4'h1;
    flag=1'b0;
    data_curr=8'h00;
    data_pre=8'h00;
  end

always @(negedge clk) //Activating at negative edge of clock from keyboard
  begin
    case(b)
      1:
        ;
      //first bit
      2:
        data_curr[0]<=data;
      3:
        data_curr[1]<=data;
      4:
        data_curr[2]<=data;
      5:
        data_curr[3]<=data;
      6:
        data_curr[4]<=data;
      7:
        data_curr[5]<=data;
      8:
        data_curr[6]<=data;
      9:
        data_curr[7]<=data;
      10:
        flag<=1'b1; //Parity bit
      11:
        flag<=1'b0; //Ending bit
    endcase
    if(b<=10)
      b<=b+1;
    else if(b==11)
      b<=1;
  end

always @(posedge flag)
  begin
    if((data_curr==W||data_curr==A||data_curr==S ||
        data_curr==D||data_curr==Space||data_curr==I||
        data_curr==J||data_curr==K||data_curr==L||
        data_curr==P||data_curr==Q||data_curr==E||
        data_curr==U||data_curr==O||data_curr==8'hf0))
      key_correct<=data_curr;
    else
      key_correct<=8'h00;

  end

always@(negedge flag)
  begin
    if(key_correct==8'h00)
      ;
    else
      begin
        if(data_pre==8'hf0)
          begin
            case(key_correct)
              W:
                keyW<=0;
              A:
                keyA<=0;
              S:
                keyS<=0;
              D:
                keyD<=0;
              Space:
                keySp<=0;
              I:
                keyI<=0;
              J:
                keyJ<=0;
              K:
                keyK<=0;
              L:
                keyL<=0;
              P:
                keyP<=0;
              Q:
                keyQ<=0;
              E:
                keyE<=0;
              U:
                keyU<=0;
              O:
                keyO<=0;
              default;
            endcase
          end
        else if(key_correct==8'hf0)
          ;
        else
          begin
            case(key_correct)
              W:
                keyW<=1;
              A:
                keyA<=1;
              S:
                keyS<=1;
              D:
                keyD<=1;
              Space:
                keySp<=1;
              I:
                keyI<=1;
              J:
                keyJ<=1;
              K:
                keyK<=1;
              L:
                keyL<=1;
              P:
                keyP<=1;
              Q:
                keyQ<=1;
              E:
                keyE<=1;
              U:
                keyU<=1;
              O:
                keyO<=1;
            endcase
          end
        data_pre<=key_correct;
      end
  end

assign  ctrl_bus={keySp,keyQ,keyE,keyW,keyS,keyA,keyD,keyP,keyU,keyO,keyI,keyK,keyJ,keyL};
endmodule

