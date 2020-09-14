-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Wed Dec 11 22:45:19 2019
-- Host        : DESKTOP-7DS5362 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub e:/VIVADOcode/Game/Game.srcs/sources_1/ip/clk_ram/clk_ram_stub.vhdl
-- Design      : clk_ram
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_ram is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_ram;

architecture stub of clk_ram is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1";
begin
end;
