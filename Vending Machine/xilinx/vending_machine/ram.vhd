library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
	port (
		clk : in std_logic;
		rd_addr : in std_logic_vector(8 downto 0);
		wr_addr : in std_logic_vector(8 downto 0);
		wr_data : in std_logic_vector(7 downto 0);
		wr_ena : in std_logic;
		rd_data : out std_logic_vector(7 downto 0)
	);
end ram;

architecture rtl of ram is
	constant NWORDS : integer := 2 ** 9;
	type ram_type is array(0 to NWORDS-1) of std_logic_vector(7 downto 0);
	-- Initialization works in simulation and in FPGAs,
	-- but not in an ASIC
	signal mem : ram_type := (others => (others => '0'));
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if wr_ena='1' then
				mem(to_integer(unsigned(wr_addr))) <= wr_data;
			end if;
			rd_data <= mem(to_integer(unsigned(rd_addr)));
		end if;
	end process;
end rtl;