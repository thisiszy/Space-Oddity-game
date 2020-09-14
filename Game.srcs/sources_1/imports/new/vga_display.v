module vga640x480(
         input wire clk,
         input wire clk_vga,
         input wire rst,
         output wire hs,
         output wire vs,
         output wire active,
         output wire animate,
         output wire [9:0] x,
         output wire [8:0] y
       );

localparam HS_STA = 16,HS_END = 16 + 96,HA_STA = 16 + 96 + 48, VS_STA = 480 + 10,VS_END = 480 + 10 + 2,VA_END = 480,LINE = 800,SCREEN = 525;

reg [9:0] h_count;  // line position
reg [9:0] v_count;  // screen position

assign hs = ~((h_count >= HS_STA) & (h_count < HS_END));
assign vs = ~((v_count >= VS_STA) & (v_count < VS_END));

assign x = (h_count < HA_STA) ? 0 : (h_count - HA_STA);
assign y = (v_count >= VA_END) ? (VA_END - 1) : (v_count);

assign active = ~((h_count < HA_STA) | (v_count > VA_END - 1));
assign animate = ((v_count == VA_END - 1) & (h_count == LINE));

always @ (posedge clk)
  begin
    if (rst)  // reset to start of frame
      begin
        h_count <= 0;
        v_count <= 0;
      end
    if (clk_vga)  // once per pixel
      begin
        if (h_count == LINE)  // end of line
          begin
            h_count <= 0;
            v_count <= v_count + 1;
          end
        else
          h_count <= h_count + 1;

        if (v_count == SCREEN)  // end of screen
          v_count <= 0;
      end
  end
endmodule
