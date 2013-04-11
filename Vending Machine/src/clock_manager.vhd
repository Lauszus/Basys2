-----------------------------------------------------------------------
-- This component divides the 50 MHz clock signal down to a 762 Hz signal
-- In addition the user can select between a manual clock
-- and the 762 Hz clock.
--
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity clock_manager is
	port(
		clk_50    : in  std_logic;   -- 50Mhz clock signal from board
		clk_man   : in  std_logic;   -- Manual clock signal
		sel_man   : in  std_logic;   -- Select signal between 762 Hz clock and manual clock
		clk       : out std_logic;  -- Output signal from clock, 762 Hz
		clk_display : out std_logic -- Clock used to update the scrolling display
	);
end clock_manager;

architecture structure of clock_manager is
signal count_present, count_next : unsigned(15 downto 0):=(others => '0'); 
attribute clock_signal : string;
attribute clock_signal of clk : signal is "yes";

signal count_present_display, count_next_display : unsigned(6 downto 0):=(others => '0');
signal clk_signal, clk_display_signal : std_logic;

begin
	clk <= clk_signal;
	clk_display <= clk_display_signal;
	
	count_next <= count_present + 1;
	count_next_display <= count_present_display + 1;
  
	process(clk_signal, sel_man, clk_man, count_present)
	begin
		if sel_man = '1' then
			clk_signal <= clk_man;
		else
			clk_signal <= count_present(15);
		end if;
	end process;
  
	process(clk_signal,clk_display_signal,count_present_display)
	begin
		if rising_edge(clk_signal) then
			if count_present_display >= 100 then -- Generate 3.81 Hz signal
				clk_display_signal <= not clk_display_signal;
				count_present_display <= (others=>'0');
			else
				count_present_display <= count_next_display;
			end if;		
		end if;
	end process;
	
	process(clk_50, count_present)
	begin
		if rising_edge(clk_50) then
			count_present <= count_next;
		end if;
	end process;
	
end structure;