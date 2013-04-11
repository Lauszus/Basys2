library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity display_text is
	port(
		clk : in std_logic;
		clk_2 : out std_logic;
		seven_segment : out std_logic_vector (7 downto 0);
		digit_select : out std_logic_vector(3 downto 0);
		
		reset : in std_logic;
		release_can : in std_logic;
		flavor : in std_logic
	);
end display_text;

architecture Behavioral of display_text is
	type state_type is (state0, state1, state2, state3, state4, state5, state6, state7);
	signal current_state : state_type;
	signal next_state : state_type;
	
	signal selector, selector_next : std_logic_vector(1 downto 0);
	signal digit_temp : std_logic_vector(3 downto 0);
	signal digit0, digit1, digit2, digit3 : std_logic_vector(3 downto 0);

	constant OFF : std_logic_vector(3 downto 0) := "0000";
	constant C : std_logic_vector(3 downto 0) := "0001";
	constant O : std_logic_vector(3 downto 0) := "0010";
	constant L : std_logic_vector(3 downto 0) := "0011";
	constant A : std_logic_vector(3 downto 0) := "0100";
	
	signal count_present, count_next: std_logic_vector(24 downto 0);
	signal clk_2_signal : std_logic;

begin
	selector_next <= selector + 1;
	count_next <= count_present + 1;
	clk_2 <= clk_2_signal;
    
	process(clk, count_present)
	begin
		if rising_edge(clk) then
			if count_present >= 191 then -- generate 2 Hz signal
				clk_2_signal <= not clk_2_signal;
				count_present <= (others=>'0');
			else
				count_present <= count_next;
			end if;
		end if;
	end process;

	process(digit_temp)
	begin
		case digit_temp is
			when "0000" => seven_segment <= "11111111"; -- Off
			when "0001" => seven_segment <= "11000110"; -- C
			when "0010" => seven_segment <= "11000000"; -- O
			when "0011" => seven_segment <= "11000111"; -- L
			when "0100" => seven_segment <= "10001000"; -- A
			when others => seven_segment <= (others=>'1');
		end case;
	end process;
	
	process(selector,digit0,digit1,digit2,digit3)
	begin
		if selector = "00" then
			digit_select <= "1110";
			digit_temp <= A;
		elsif selector = "01" then
			digit_select <= "1101";
			digit_temp <= L;
		elsif selector = "10" then
			digit_select <= "1011";
			digit_temp <= O;
		else
			digit_select <= "0111";
			digit_temp <= C;
		end if;	
	end process;

	process(clk,reset,release_can)
	begin
		if reset = '1' or release_can = '0' then
			--current_state <= state0;
		elsif rising_edge(clk) then
			--current_state <= next_state;
			if selector < "11" then
				selector <= selector_next;
			else
				selector <= (others=>'0');
			end if;
		end if;
	end process;
	
--	process(current_state)
--	begin
--		if current_state = state0 then
--			next_state <= state1;
--			digit0 <= OFF;
--			digit1 <= OFF;
--			digit2 <= OFF;
--			digit3 <= OFF;
--		elsif current_state = state1 then
--			next_state <= state2;
--			digit0 <= C;
--			digit1 <= OFF;
--			digit2 <= OFF;
--			digit3 <= OFF;
--		elsif current_state = state2 then
--			next_state <= state3;
--			digit0 <= O;
--			digit1 <= C;
--			digit2 <= OFF;
--			digit3 <= OFF;
--		elsif current_state = state3 then
--			next_state <= state4;
--			digit0 <= L;
--			digit1 <= O;
--			digit2 <= C;
--			digit3 <= OFF;
--		elsif current_state = state4 then
--			next_state <= state5;
--			digit0 <= A;
--			digit1 <= L;
--			digit2 <= O;
--			digit3 <= C;
--		elsif current_state = state5 then
--			next_state <= state6;
--			digit0 <= OFF;
--			digit1 <= A;
--			digit2 <= L;
--			digit3 <= O;
--		elsif current_state = state6 then
--			next_state <= state7;
--			digit0 <= OFF;
--			digit1 <= OFF;
--			digit2 <= A;
--			digit3 <= L;
--		elsif current_state = state7 then
--			next_state <= state0;
--			digit0 <= OFF;
--			digit1 <= OFF;
--			digit2 <= OFF;
--			digit3 <= A;
--		else
--			next_state <= state0;
--		end if;
--	end process;
	
	--	process(current_state)
--	begin
--		next_state <= current_state;
--		
--		case current_state is
--			when default_state =>
--				if coin2 = '1' then
--					next_state <= coin2_state;
--				elsif coin5 = '1' then
--					next_state <= coin5_state;
--				elsif buy = '1' then
--					next_state <= buy_state;
--				end if;
--			when coin2_state =>
--				if coin2 = '0' then
--					next_state <= default_state;
--				end if;
--			when coin5_state =>
--				if coin5 = '0' then
--					next_state <= default_state;
--				end if;
--			when buy_state =>
--				if buy = '0' then
--					next_state <= default_state;
--				end if;
--		end case;
--	end process;
	
end Behavioral;