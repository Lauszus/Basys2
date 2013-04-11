library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_manager is
	port (
		price : in std_logic_vector(4 downto 0);
		coin_sum: in std_logic_vector(4 downto 0);
		seven_segment : out std_logic_vector (7 downto 0);
		digit_select : out std_logic_vector(3 downto 0);
		release_can : in std_logic;
		clk : in std_logic;
		clk_2 : out std_logic;
		reset : in std_logic
	);
end display_manager;

architecture Behavioral of display_manager is
	component display_10base
	port(
		price : in std_logic_vector(4 downto 0);
		coin_sum : in std_logic_vector(4 downto 0);
		clk : in std_logic;          
		seven_segment : out std_logic_vector(7 downto 0);
		digit_select : out std_logic_vector(3 downto 0)
		);
	end component;
	
	COMPONENT display_text
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		release_can : IN std_logic;
		flavor : IN std_logic;          
		clk_2 : OUT std_logic;
		seven_segment : OUT std_logic_vector(7 downto 0);
		digit_select : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	signal seven_segment_temp, seven_segment_text, seven_segment_10base : std_logic_vector (7 downto 0);
	signal digit_select_temp, digit_select_text, digit_select_10base : std_logic_vector(3 downto 0);
	

begin
	seven_segment <= seven_segment_temp;
	digit_select <= digit_select_temp;

	process(release_can,seven_segment_text,digit_select_text,seven_segment_10base,digit_select_10base)
	begin
		--if rising_edge(clk) then
			if release_can = '1' then
				seven_segment_temp <= seven_segment_text;
				digit_select_temp <= digit_select_text;
			else
				seven_segment_temp <= seven_segment_10base;
				digit_select_temp <= digit_select_10base;
			end if;
		--end if;
	end process;

--	Inst_display_text: display_text PORT MAP(
--		clk => clk,
--		clk_2 => clk_2,
--		seven_segment => seven_segment_text,
--		digit_select => digit_select_text,
--		reset => reset,
--		release_can => release_can,
--		flavor => '0'
--	);
	
	Inst_display_10base: display_10base port map (
		price => price,
		coin_sum => coin_sum,
		seven_segment => seven_segment_10base,
		digit_select => digit_select_10base,
		clk => clk);

end Behavioral;

