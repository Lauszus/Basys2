-------------------------------------------------------------
-- Vi synkroniserer med klokken for at undgå metastabilitet
-------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_sync is
	port(
	clk : in std_logic;
	reset_in : in std_logic;
	coin2_in : in std_logic;
	coin5_in : in std_logic;
	buy_in : in std_logic;
	price_in : in std_logic_vector(4 downto 0);
	
	reset : out std_logic;
	coin2 : out std_logic;
	coin5 : out std_logic;
	buy : out std_logic;
	price : out std_logic_vector(4 downto 0));
end input_sync;

architecture Behavioral of input_sync is

begin
	process(clk)
	begin
		if rising_edge(clk) then
			reset <= reset_in;
			coin2 <= coin2_in;
			coin5 <= coin5_in;
			buy <= buy_in;
			price <= price_in;
		end if;
	end process;
end Behavioral;