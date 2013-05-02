library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_manager is
	port (
		clk_50 : in std_logic; -- 50MHz clock
		clk : in std_logic;
		reset : in std_logic;
		tx : out std_logic;
		--rx : in std_logic;
		--receiveBuffer : out std_logic_vector(7 downto 0);
		price : in std_logic_vector(5 downto 0);
		coin_sum: in std_logic_vector(6 downto 0);
		seven_segment : out std_logic_vector (7 downto 0);
		digit_select : out std_logic_vector(3 downto 0);
		buy : in std_logic;
		release_can : in std_logic;
		alarm : in std_logic;
		new_value : in std_logic
	);
end display_manager;

architecture Behavioral of display_manager is
	COMPONENT display_10base
	PORT(
		clk_50 : IN std_logic;
		reset : IN std_logic;
		price : IN std_logic_vector(5 downto 0);
		coin_sum : IN std_logic_vector(6 downto 0);
		clk : IN std_logic;          
		tx : OUT std_logic;
		seven_segment : OUT std_logic_vector(7 downto 0);
		digit_select : OUT std_logic_vector(3 downto 0);
		new_value : IN std_logic
		);
	END COMPONENT;
	
	COMPONENT display_text
	PORT(
		clk : IN std_logic;
		seven_segment : OUT std_logic_vector(7 downto 0);
		digit_select : OUT std_logic_vector(3 downto 0);
		reset : IN std_logic;
		release_can : IN std_logic;
		alarm : IN std_logic;
		flavor : IN std_logic
		);
	END COMPONENT;
	
	signal seven_segment_temp, seven_segment_text, seven_segment_10base : std_logic_vector (7 downto 0);
	signal digit_select_temp, digit_select_text, digit_select_10base : std_logic_vector(3 downto 0);	

begin
	seven_segment <= seven_segment_temp;
	digit_select <= digit_select_temp;

	process(buy,seven_segment_text,digit_select_text,seven_segment_10base,digit_select_10base)
	begin
		if buy = '1' then
			seven_segment_temp <= seven_segment_text;
			digit_select_temp <= digit_select_text;
		else
			seven_segment_temp <= seven_segment_10base;
			digit_select_temp <= digit_select_10base;
		end if;
	end process;

	Inst_display_text: display_text PORT MAP(
		clk => clk,
		seven_segment => seven_segment_text,
		digit_select => digit_select_text,
		reset => reset,
		release_can => release_can,
		alarm => alarm,
		flavor => price(0) -- Determine flavor based on if it's an equal or unequal number
	);
	
	Inst_display_10base: display_10base PORT MAP(
		clk_50 => clk_50,
		clk => clk,
		reset => reset,
		tx => tx,
		price => price,
		coin_sum => coin_sum,
		seven_segment => seven_segment_10base,
		digit_select => digit_select_10base,
		new_value => new_value
	);

end Behavioral;