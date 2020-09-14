`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/19/2019 09:04:14 PM
// Design Name:
// Module Name: game_body
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


module game_body(
         input CLK,
         input clk_ram,
         input clk_vga,
         input rst,
         input [9:0]x,
         input [8:0]y,
         input animate,
         input [13:0]ctrl_bus_in,
         input [2:0]state,
         output [1:0]over,
         output reg [11:0]RGB,
         output start_page_done,
         output final_page_done
       );
/******************************************************************************************************************/
//background
reg [9:0]addr;
wire [11:0]color_background;
wire [11:0]color[27:0];
reg [4:0]background_offset;
reg v_background;
wire [13:0]sys_ctrl;
wire [13:0]ctrl_bus;

assign ctrl_bus = (state==3'b001) ?  sys_ctrl : ctrl_bus_in;

sram #(.ADDR_WIDTH(10), .DATA_WIDTH(12), .DEPTH(1024), .MEMFILE("background.mem")) background(
       .i_clk(clk_ram),
       .i_addr(addr),
       .i_write(0),
       .i_data(0),
       .o_data(color[27])
     );

always @(posedge CLK)
  begin
    addr <= {y[4:0],x[4:0]+background_offset};
  end

always @(posedge animate)
  begin
    v_background<=v_background+1;
  end

always @(posedge v_background)
  begin
    background_offset<=background_offset+1;
  end

/******************************************************************************************************************/
//character control

wire [27:0]color_on;
wire color_on_final;
wire [11:0]color_final;
wire color_on_start;
wire [11:0]color_start;
wire color_on_final_page_2;
wire [11:0]color_final_page_2;
wire fire_on1;
wire fire_on2;
wire [9:0]pos_x_1;
wire [8:0]pos_y_1;
wire [9:0]pos_x_2;
wire [8:0]pos_y_2;
wire [4:0]rotate_1;
wire [4:0]rotate_2;
wire direction1;
wire direction2;
assign direction1 = (ctrl_bus[3] & ~ctrl_bus[2]) ? 1'b1 : 1'b0;
assign direction2 = (ctrl_bus[10] & ~ctrl_bus[9]) ? 1'b1 : 1'b0;

character #(.initial_x(360),.initial_y(240)) character1(
            .clk(CLK),
            .clk_ram(clk_ram),
            .RST(rst),
            .x(x),
            .y(y),
            .ctrl_bus(ctrl_bus[6:0]),
            .color_on(color_on[0]),
            .color(color[0]),
            .fire_on(fire_on1),
            .pos_x(pos_x_1),
            .pos_y(pos_y_1),
            .rotate(rotate_1)
            //            .fire_type(fire_type)
          );

character #(.initial_x(120),.initial_y(240),.MEMFILE("ship2.mem"))character2(
            .clk(CLK),
            .clk_ram(clk_ram),
            .RST(rst),
            .x(x),
            .y(y),
            .ctrl_bus(ctrl_bus[13:7]),
            .color_on(color_on[1]),
            .color(color[1]),
            .fire_on(fire_on2),
            .pos_x(pos_x_2),
            .pos_y(pos_y_2),
            .rotate(rotate_2)
            //            .fire_type(fire_type2)
          );


/************************************************************************************************************************/
reg [25:0]en;

meteorolite  #(.seed(234567))meteorolite1(
               .clk(CLK),
               .clk_ram(clk_ram),
               .x(x),
               .y(y),
               .en(en[2]),
               .meteorolite_type(0),
               .color_on(color_on[2]),
               .color(color[2])
             );

meteorolite #(.seed(124569))meteorolite2(
              .clk(CLK),
              .clk_ram(clk_ram),
              .x(x),
              .y(y),
              .en(en[3]),
              .meteorolite_type(1),
              .color_on(color_on[3]),
              .color(color[3])
            );

meteorolite #(.seed(274567))meteorolite3(
              .clk(CLK),
              .clk_ram(clk_ram),
              .x(x),
              .y(y),
              .en(en[4]),
              .meteorolite_type(1),
              .color_on(color_on[4]),
              .color(color[4])
            );

meteorolite #(.seed(134567))meteorolite4(
              .clk(CLK),
              .clk_ram(clk_ram),
              .x(x),
              .y(y),
              .en(en[5]),
              .meteorolite_type(0),
              .color_on(color_on[5]),
              .color(color[5])
            );

meteorolite #(.seed(434567))meteorolite5(
              .clk(CLK),
              .clk_ram(clk_ram),
              .x(x),
              .y(y),
              .en(en[6]),
              .meteorolite_type(1),
              .color_on(color_on[6]),
              .color(color[6])
            );

meteorolite #(.seed(934567))meteorolite6(
              .clk(CLK),
              .clk_ram(clk_ram),
              .x(x),
              .y(y),
              .en(en[7]),
              .meteorolite_type(1),
              .color_on(color_on[7]),
              .color(color[7])
            );

meteorolite #(.seed(1834567))meteorolite7(
              .clk(CLK),
              .clk_ram(clk_ram),
              .x(x),
              .y(y),
              .en(en[8]),
              .meteorolite_type(1),
              .color_on(color_on[8]),
              .color(color[8])
            );

meteorolite #(.seed(114567))meteorolite8(
              .clk(CLK),
              .clk_ram(clk_ram),
              .x(x),
              .y(y),
              .en(en[9]),
              .meteorolite_type(1),
              .color_on(color_on[9]),
              .color(color[9])
            );
/************************************************************************************************************************/
//fire control
wire [11:0]fire_ready;
reg [7:0]rst_pos;
fire fire1(
       .clk(CLK),
       .rst(rst_pos[0]),
       .clk_ram(clk_ram),
       .x(x),
       .y(y),
       .pos_x(pos_x_1),
       .pos_y(pos_y_1),
       .rotation(rotate_1),
       .en(en[10]),
       .direction(direction1),
       .color_on(color_on[10]),
       .color(color[10]),
       .ready(fire_ready[0])
     );
fire fire2(
       .clk(CLK),
       .rst(rst_pos[1]),
       .clk_ram(clk_ram),
       .x(x),
       .y(y),
       .pos_x(pos_x_1),
       .pos_y(pos_y_1),
       .rotation(rotate_1),
       .en(en[11]),
       .direction(direction1),
       .color_on(color_on[11]),
       .color(color[11]),
       .ready(fire_ready[1])
     );
fire fire3(
       .clk(CLK),
       .rst(rst_pos[2]),
       .clk_ram(clk_ram),
       .x(x),
       .y(y),
       .pos_x(pos_x_1),
       .pos_y(pos_y_1),
       .rotation(rotate_1),
       .en(en[12]),
       .direction(direction1),
       .color_on(color_on[12]),
       .color(color[12]),
       .ready(fire_ready[2])
     );
fire fire4(
       .clk(CLK),
       .rst(rst_pos[3]),
       .clk_ram(clk_ram),
       .x(x),
       .y(y),
       .pos_x(pos_x_1),
       .pos_y(pos_y_1),
       .rotation(rotate_1),
       .en(en[13]),
       .direction(direction1),
       .color_on(color_on[13]),
       .color(color[13]),
       .ready(fire_ready[3])
     );

fire #(.type(1))fire5(
       .clk(CLK),
       .rst(rst_pos[4]),
       .clk_ram(clk_ram),
       .x(x),
       .y(y),
       .pos_x(pos_x_2),
       .pos_y(pos_y_2),
       .rotation(rotate_2),
       .en(en[14]),
       .direction(direction2),
       .color_on(color_on[14]),
       .color(color[14]),
       .ready(fire_ready[4])
     );
fire #(.type(1))fire6(
       .clk(CLK),
       .rst(rst_pos[5]),
       .clk_ram(clk_ram),
       .x(x),
       .y(y),
       .pos_x(pos_x_2),
       .pos_y(pos_y_2),
       .rotation(rotate_2),
       .en(en[15]),
       .direction(direction2),
       .color_on(color_on[15]),
       .color(color[15]),
       .ready(fire_ready[5])
     );
fire #(.type(1))fire7(
       .clk(CLK),
       .rst(rst_pos[6]),
       .clk_ram(clk_ram),
       .x(x),
       .y(y),
       .pos_x(pos_x_2),
       .pos_y(pos_y_2),
       .rotation(rotate_2),
       .en(en[16]),
       .direction(direction2),
       .color_on(color_on[16]),
       .color(color[16]),
       .ready(fire_ready[6])
     );
fire #(.type(1))fire8(
       .clk(CLK),
       .rst(rst_pos[7]),
       .clk_ram(clk_ram),
       .x(x),
       .y(y),
       .pos_x(pos_x_2),
       .pos_y(pos_y_2),
       .rotation(rotate_2),
       .en(en[17]),
       .direction(direction2),
       .color_on(color_on[17]),
       .color(color[17]),
       .ready(fire_ready[7])
     );
/************************************************************************************************************************/
//collision detection
wire [2:0]damage;

collision_detection (
    .clk(CLK),
    .color_on(color_on),//low 2 bits from user the rest from fire
    .damage_pulse(damage)
  );

/************************************************************************************************************************/
//HP calc
wire [11:0]color_score;
score HP(
        .clk(CLK),
        .clk_ram(clk_ram),
        .rst(rst),
        .x(x),
        .y(y),
        .damage(damage),
        .state(state),
        .color(color_score),
        .over(over)
      );
/************************************************************************************************************************/
//draw control
always @(posedge clk_vga)
  begin
    if(y<=32)
      RGB<=color_score;
    else
      begin
        if(x>32 & (x<640-32) & (y<480-32))
          begin
            if(color_on_final_page_2)
              RGB<=color_final_page_2;
            else if(color_on_start)
              RGB<=color_start;
            else if(color_on_final)
              RGB<=color_final;
            else if(color_on[0])
              RGB<=color[0];
            else if(color_on[1])
              RGB<=color[1];
            else if(color_on[2])
              RGB<=color[2];
            else if(color_on[3])
              RGB<=color[3];
            else if(color_on[4])
              RGB<=color[4];
            else if(color_on[5])
              RGB<=color[5];
            else if(color_on[6])
              RGB<=color[6];
            else if(color_on[7])
              RGB<=color[7];
            else if(color_on[8])
              RGB<=color[8];
            else if(color_on[9])
              RGB<=color[9];
            else if(color_on[10])
              RGB<=color[10];
            else if(color_on[11])
              RGB<=color[11];
            else if(color_on[12])
              RGB<=color[12];
            else if(color_on[13])
              RGB<=color[13];
            else if(color_on[14])
              RGB<=color[14];
            else if(color_on[15])
              RGB<=color[15];
            else if(color_on[16])
              RGB<=color[16];
            else if(color_on[17])
              RGB<=color[17];
            else
              RGB<=color[27];
          end
        else
          RGB<=12'h000;
      end
  end
// end

/************************************************************************************************************************/
//main_control
wire damageflag;
wire enemy_create;
assign damageflag=|damage;
wire [31:0]enemy_rst_Target;

always @(posedge CLK)//posedge enemy_create or posedge damageflag or posedge fire_on)//
  begin
    if(fire_on1 & ~damageflag)
      begin
        if(fire_ready[0])
          begin
            en[10]<=1;
            rst_pos[0]<=~rst_pos[0];
          end
        else if(fire_ready[1])
          begin
            en[11]<=1;
            rst_pos[1]<=~rst_pos[1];
          end
        else if(fire_ready[2])
          begin
            en[12]<=1;
            rst_pos[2]<=~rst_pos[2];
          end
        else if(fire_ready[3])
          begin
            en[13]<=1;
            rst_pos[3]<=~rst_pos[3];
          end
        else
          ;
      end
    else if(~fire_on1 & damageflag)
      begin
        if(color_on[10])
          en[10]<=0;
        if(color_on[11])
          en[11]<=0;
        if(color_on[12])
          en[12]<=0;
        if(color_on[13])
          en[13]<=0;
        else
          ;
      end

    if(fire_on2 & ~damageflag)
      begin
        if(fire_ready[4])
          begin
            en[14]<=1;
            rst_pos[4]<=~rst_pos[4];
          end
        else if(fire_ready[5])
          begin
            en[15]<=1;
            rst_pos[5]<=~rst_pos[5];
          end
        else if(fire_ready[6])
          begin
            en[16]<=1;
            rst_pos[6]<=~rst_pos[6];
          end
        else if(fire_ready[7])
          begin
            en[17]<=1;
            rst_pos[7]<=~rst_pos[7];
          end
        else
          ;
      end
    else if(~fire_on2 & damageflag)
      begin
        if(color_on[14])
          en[14]<=0;
        if(color_on[15])
          en[15]<=0;
        if(color_on[16])
          en[16]<=0;
        if(color_on[17])
          en[17]<=0;
        else
          ;
      end

    if((enemy_rst_Target[2:0]==0) & ~damageflag)
      en[2]<=1;
    else if(damageflag & color_on[2])
      en[2]<=0;
    if((enemy_rst_Target[2:0]==1) & ~damageflag)
      en[3]<=1;
    else if(damageflag & color_on[3])
      en[3]<=0;
    if((enemy_rst_Target[2:0]==2) & ~damageflag)
      en[4]<=1;
    else if(damageflag & color_on[4])
      en[4]<=0;
    if((enemy_rst_Target[2:0]==3) & ~damageflag)
      en[5]<=1;
    else if(damageflag & color_on[5])
      en[5]<=0;
    if((enemy_rst_Target[2:0]==4) & ~damageflag)
      en[6]<=1;
    else if(damageflag & color_on[6])
      en[6]<=0;
    if((enemy_rst_Target[2:0]==5) & ~damageflag)
      en[7]<=1;
    else if(damageflag & color_on[7])
      en[7]<=0;
    if((enemy_rst_Target[2:0]==6) & ~damageflag)
      en[8]<=1;
    else if(damageflag & color_on[8])
      en[8]<=0;
    if((enemy_rst_Target[2:0]==7) & ~damageflag)
      en[9]<=1;
    else if(damageflag & color_on[9])
      en[9]<=0;
  end

assign enemy_rst_Target = pos_x_1+pos_y_1++pos_y_2+pos_y_2+1234567;

clock clock1(
        .clk(CLK),
        .rst_Target(enemy_rst_Target),
        .auto_rst(1),
        .clk_out(enemy_create)
      );

start_page start(
             .clk(CLK),
             .clk_ram(clk_ram),
             .rst(rst),
             .x(x),
             .y(y),
             .x_1(pos_x_1),
             .y_1(pos_y_1),
             .rotate_1(rotate_1),
             .x_2(pos_x_2),
             .y_2(pos_y_2),
             .rotate_2(rotate_2),
             .state(state),
             .color_on(color_on_start),
             .color(color_start),
             .sys_ctrl(sys_ctrl),
             .done(start_page_done)
           );

final_page final(
             .clk(CLK),
             .clk_ram(clk_ram),
             .rst(rst),
             .x(x),
             .y(y),
             .x_1(pos_x_1),
             .y_1(pos_y_1),
             .x_2(pos_x_2),
             .y_2(pos_y_2),
             .over(over),
             .state(state),
             .pulse(animate),//1 tick per screen
             .color_on(color_on_final),
             .color(color_final),
             .done(final_page_done)
           );

final_page_2 final_2(
               .clk(CLK),
               .clk_ram(clk_ram),
               .x(x),
               .y(y),
               .state(state),
               .color_on(color_on_final_page_2),
               .color(color_final_page_2)
             );

endmodule
