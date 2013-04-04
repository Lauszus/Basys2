--------------------------------------------------------------------------------
-- Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.28xd
--  \   \         Application: netgen
--  /   /         Filename: display7seg_decoder_synthesis.vhd
-- /___/   /\     Timestamp: Thu Mar 14 14:16:35 2013
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -ar Structure -tm display7seg_decoder -w -dir netgen/synthesis -ofmt vhdl -sim display7seg_decoder.ngc display7seg_decoder_synthesis.vhd 
-- Device	: xc3s100e-5-cp132
-- Input file	: display7seg_decoder.ngc
-- Output file	: C:\02139\lab\xilinx\vending_machine\netgen\synthesis\display7seg_decoder_synthesis.vhd
-- # of Entities	: 1
-- Design Name	: display7seg_decoder
-- Xilinx	: C:\Xilinx\14.2\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity display7seg_decoder is
  port (
    seven_segment : out STD_LOGIC_VECTOR ( 6 downto 0 ); 
    binary_number : in STD_LOGIC_VECTOR ( 4 downto 0 ) 
  );
end display7seg_decoder;

architecture Structure of display7seg_decoder is
  signal N32 : STD_LOGIC; 
  signal binary_number_0_IBUF_6 : STD_LOGIC; 
  signal binary_number_1_IBUF_7 : STD_LOGIC; 
  signal binary_number_2_IBUF_8 : STD_LOGIC; 
  signal binary_number_3_IBUF_9 : STD_LOGIC; 
  signal binary_number_4_IBUF_10 : STD_LOGIC; 
  signal seven_segment_0_1_12 : STD_LOGIC; 
  signal seven_segment_1_1_14 : STD_LOGIC; 
  signal seven_segment_2_1_16 : STD_LOGIC; 
  signal seven_segment_3_1_18 : STD_LOGIC; 
  signal seven_segment_4_1_20 : STD_LOGIC; 
  signal seven_segment_5_1_22 : STD_LOGIC; 
  signal seven_segment_6_1_24 : STD_LOGIC; 
  signal seven_segment_0_OBUF_25 : STD_LOGIC; 
  signal seven_segment_1_OBUF_26 : STD_LOGIC; 
  signal seven_segment_2_OBUF_27 : STD_LOGIC; 
  signal seven_segment_3_OBUF_28 : STD_LOGIC; 
  signal seven_segment_4_OBUF_29 : STD_LOGIC; 
  signal seven_segment_5_OBUF_30 : STD_LOGIC; 
  signal seven_segment_6_OBUF_31 : STD_LOGIC; 
begin
  binary_number_4_IBUF : IBUF
    port map (
      I => binary_number(4),
      O => binary_number_4_IBUF_10
    );
  binary_number_3_IBUF : IBUF
    port map (
      I => binary_number(3),
      O => binary_number_3_IBUF_9
    );
  binary_number_2_IBUF : IBUF
    port map (
      I => binary_number(2),
      O => binary_number_2_IBUF_8
    );
  binary_number_1_IBUF : IBUF
    port map (
      I => binary_number(1),
      O => binary_number_1_IBUF_7
    );
  binary_number_0_IBUF : IBUF
    port map (
      I => binary_number(0),
      O => binary_number_0_IBUF_6
    );
  seven_segment_6_OBUF : OBUF
    port map (
      I => seven_segment_6_OBUF_31,
      O => seven_segment(6)
    );
  seven_segment_5_OBUF : OBUF
    port map (
      I => seven_segment_5_OBUF_30,
      O => seven_segment(5)
    );
  seven_segment_4_OBUF : OBUF
    port map (
      I => seven_segment_4_OBUF_29,
      O => seven_segment(4)
    );
  seven_segment_3_OBUF : OBUF
    port map (
      I => seven_segment_3_OBUF_28,
      O => seven_segment(3)
    );
  seven_segment_2_OBUF : OBUF
    port map (
      I => seven_segment_2_OBUF_27,
      O => seven_segment(2)
    );
  seven_segment_1_OBUF : OBUF
    port map (
      I => seven_segment_1_OBUF_26,
      O => seven_segment(1)
    );
  seven_segment_0_OBUF : OBUF
    port map (
      I => seven_segment_0_OBUF_25,
      O => seven_segment(0)
    );
  XST_GND : GND
    port map (
      G => N32
    );
  seven_segment_2_1 : LUT4
    generic map(
      INIT => X"FB31"
    )
    port map (
      I0 => binary_number_2_IBUF_8,
      I1 => binary_number_0_IBUF_6,
      I2 => binary_number_1_IBUF_7,
      I3 => binary_number_3_IBUF_9,
      O => seven_segment_2_1_16
    );
  seven_segment_2_f5 : MUXF5
    port map (
      I0 => seven_segment_2_1_16,
      I1 => N32,
      S => binary_number_4_IBUF_10,
      O => seven_segment_2_OBUF_27
    );
  seven_segment_4_1 : LUT4
    generic map(
      INIT => X"5EDF"
    )
    port map (
      I0 => binary_number_2_IBUF_8,
      I1 => binary_number_0_IBUF_6,
      I2 => binary_number_3_IBUF_9,
      I3 => binary_number_1_IBUF_7,
      O => seven_segment_4_1_20
    );
  seven_segment_4_f5 : MUXF5
    port map (
      I0 => seven_segment_4_1_20,
      I1 => N32,
      S => binary_number_4_IBUF_10,
      O => seven_segment_4_OBUF_29
    );
  seven_segment_1_1 : LUT4
    generic map(
      INIT => X"A6EF"
    )
    port map (
      I0 => binary_number_3_IBUF_9,
      I1 => binary_number_2_IBUF_8,
      I2 => binary_number_1_IBUF_7,
      I3 => binary_number_0_IBUF_6,
      O => seven_segment_1_1_14
    );
  seven_segment_1_f5 : MUXF5
    port map (
      I0 => seven_segment_1_1_14,
      I1 => N32,
      S => binary_number_4_IBUF_10,
      O => seven_segment_1_OBUF_26
    );
  seven_segment_0_1 : LUT4
    generic map(
      INIT => X"BFDA"
    )
    port map (
      I0 => binary_number_3_IBUF_9,
      I1 => binary_number_0_IBUF_6,
      I2 => binary_number_2_IBUF_8,
      I3 => binary_number_1_IBUF_7,
      O => seven_segment_0_1_12
    );
  seven_segment_0_f5 : MUXF5
    port map (
      I0 => seven_segment_0_1_12,
      I1 => N32,
      S => binary_number_4_IBUF_10,
      O => seven_segment_0_OBUF_25
    );
  seven_segment_6_1 : LUT4
    generic map(
      INIT => X"F76B"
    )
    port map (
      I0 => binary_number_3_IBUF_9,
      I1 => binary_number_0_IBUF_6,
      I2 => binary_number_2_IBUF_8,
      I3 => binary_number_1_IBUF_7,
      O => seven_segment_6_1_24
    );
  seven_segment_6_f5 : MUXF5
    port map (
      I0 => seven_segment_6_1_24,
      I1 => N32,
      S => binary_number_4_IBUF_10,
      O => seven_segment_6_OBUF_31
    );
  seven_segment_5_1 : LUT4
    generic map(
      INIT => X"497F"
    )
    port map (
      I0 => binary_number_3_IBUF_9,
      I1 => binary_number_0_IBUF_6,
      I2 => binary_number_1_IBUF_7,
      I3 => binary_number_2_IBUF_8,
      O => seven_segment_5_1_22
    );
  seven_segment_5_f5 : MUXF5
    port map (
      I0 => seven_segment_5_1_22,
      I1 => N32,
      S => binary_number_4_IBUF_10,
      O => seven_segment_5_OBUF_30
    );
  seven_segment_3_1 : LUT4
    generic map(
      INIT => X"7B6D"
    )
    port map (
      I0 => binary_number_2_IBUF_8,
      I1 => binary_number_1_IBUF_7,
      I2 => binary_number_0_IBUF_6,
      I3 => binary_number_3_IBUF_9,
      O => seven_segment_3_1_18
    );
  seven_segment_3_f5 : MUXF5
    port map (
      I0 => seven_segment_3_1_18,
      I1 => N32,
      S => binary_number_4_IBUF_10,
      O => seven_segment_3_OBUF_28
    );

end Structure;

