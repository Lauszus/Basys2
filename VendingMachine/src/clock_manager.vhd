-----------------------------------------------------------------------
-- This component divides the 50 MHz clock signal down to a 762 Hz signal
-- In addition the user can select between a manual clock
-- and the 763 Hz clock.
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity clock_manager is
	port(
		clk_50    : in  std_logic; -- 50Mhz clock signal from board
		clk_man   : in  std_logic; -- Manual clock signal
		sel_man   : in  std_logic; -- Select signal between 763 Hz clock and manual clock
		clk       : out std_logic -- Output signal from clock, 763 Hz
	);
end clock_manager;

architecture structure of clock_manager is
signal count_present, count_next : unsigned(15 downto 0):=(others => '0'); 
attribute clock_signal : string;
attribute clock_signal of clk : signal is "yes";

begin
	count_next <= count_present + 1;
  
	process(sel_man, clk_man, count_present)
	begin
		if sel_man = '1' then
			clk <= clk_man;
		else
			clk <= count_present(15);
		end if;
	end process;
	
	process(clk_50, count_present)
	begin
		if rising_edge(clk_50) then
			count_present <= count_next;
		end if;
	end process;
	
end structure;