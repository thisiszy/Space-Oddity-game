module score(
         input clk,
         input clk_ram,
         input rst,
         input [9:0]x,
         input [8:0]y,
         input [2:0]damage,
         input [2:0]state,
         output [11:0]color,
         output reg [1:0]over
       );

reg [3:0]HP1;
reg [3:0]HP2;
reg [11:0]addr;

initial
  begin
    over=2'b00;
    HP1=8'h08;
    HP2=8'h08;
  end

always @(posedge clk or posedge rst)
  begin
    if(rst)
      begin
        HP1<=8;
        HP2<=8;
      end
    else if(state==3'b010)
      begin
        if((|HP1) & (|HP2))
          begin
            case(damage)
              3'b100:
                begin
                  HP1<=0;
                  HP2<=0;
                end
              3'b001:
                HP1<=HP1-1;
              3'b010:
                HP2<=HP2-1;
              default
              begin
                HP1<=HP1;
                HP2<=HP2;
              end
            endcase
          end
        else
          begin
            HP1<=HP1;
            HP2<=HP2;
          end
      end
    over<={|HP1,|HP2};
  end

sram #(.ADDR_WIDTH(12), .DATA_WIDTH(12), .DEPTH(1280), .MEMFILE("font.mem")) background(
       .i_clk(clk_ram),
       .i_addr(addr),
       .i_write(0),
       .i_data(0),
       .o_data(color)
     );


always @(posedge clk)
  begin
    if((y>=20) & (y<28))
      begin
        if((x>=64) & (x<104))
          addr <= 80+(y-20)*160+x-64;
        else if((x>=106) & (x<113))
          addr <= HP1 * 8 + (y-20) * 160 + x-106;
        else if((x>=164) & (x<204))
          addr <= 120 + (y-20) *160 + x-164;
        else if((x>=206) & (x<213))
          addr <= HP2 * 8 + (y-20) *160 + x-206;
        else
          addr<=9;
      end
    else
      begin
        addr<=9;
      end
  end

endmodule
