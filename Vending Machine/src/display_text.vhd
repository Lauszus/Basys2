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
		alarm : in std_logic;
		flavor : in std_logic
	);
end display_text;

architecture Behavioral of display_text is
	type state_type is (state0, state1, state2, state3, state4, state5, state6, state7, errorState);
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
	constant E : std_logic_vector(3 downto 0) := "0101";
	constant r : std_logic_vector(3 downto 0) := "0110";
	
	signal count_present, count_next: std_logic_vector(24 downto 0);
	signal clk_2_signal : std_logic;

begin
	selector_next <= selector + 1;
	count_next <= count_present + 1;
	clk_2 <= clk_2_signal;
	
	process(clk)
	begin		
		if rising_edge(clk) then		
			if selector < "11" then
				selector <= selector_next;
			else
				selector <= (others=>'0');
			end if;
		end if;		
	end process;
	
	process(clk,count_present)
	begin		
		if rising_edge(clk) then
			if count_present >= 100 then -- Generate 3.81 Hz signal				
				clk_2_signal <= not clk_2_signal;				
				count_present <= (others=>'0');
			else
				count_present <= count_next;
			end if;		
		end if;
	end process;
	
	process(clk_2_signal,reset,release_can,alarm)
	begin
		if reset = '1' then
			current_state <= state0;
		elsif alarm = '1' then
			current_state <= errorState;
		elsif release_can = '0' then
			current_state <= state0;
		elsif rising_edge(clk_2_signal) then
			current_state <= next_state;
		end if;
	end process;

	process(digit_temp)
	begin
		case digit_temp is
			when OFF => seven_segment <= "11111111";
			when C => seven_segment <= "11000110";
			when O => seven_segment <= "11000000";
			when L => seven_segment <= "11000111";
			when A => seven_segment <= "10001000";
			when E => seven_segment <= "10000110";
			when r => seven_segment <= "10101111";
			when others => seven_segment <= (others=>'1');
		end case;
	end process;
	
	process(selector,digit0,digit1,digit2,digit3)
	begin
		if selector = "00" then
			digit_select <= "1110";
			digit_temp <= digit0;
		elsif selector = "01" then
			digit_select <= "1101";
			digit_temp <= digit1;
		elsif selector = "10" then
			digit_select <= "1011";
			digit_temp <= digit2;
		else
			digit_select <= "0111";
			digit_temp <= digit3;
		end if;	
	end process;
	
	process(current_state)
	begin
		if current_state = state0 then
			next_state <= state1;
			digit0 <= OFF;
			digit1 <= OFF;
			digit2 <= OFF;
			digit3 <= OFF;
		elsif current_state = state1 then
			next_state <= state2;
			digit0 <= C;
			digit1 <= OFF;
			digit2 <= OFF;
			digit3 <= OFF;
		elsif current_state = state2 then
			next_state <= state3;
			digit0 <= O;
			digit1 <= C;
			digit2 <= OFF;
			digit3 <= OFF;
		elsif current_state = state3 then
			next_state <= state4;
			digit0 <= L;
			digit1 <= O;
			digit2 <= C;
			digit3 <= OFF;
		elsif current_state = state4 then
			next_state <= state5;
			digit0 <= A;
			digit1 <= L;
			digit2 <= O;
			digit3 <= C;
		elsif current_state = state5 then
			next_state <= state6;
			digit0 <= OFF;
			digit1 <= A;
			digit2 <= L;
			digit3 <= O;
		elsif current_state = state6 then
			next_state <= state7;
			digit0 <= OFF;
			digit1 <= OFF;
			digit2 <= A;
			digit3 <= L;
		elsif current_state = state7 then
			next_state <= state0;
			digit0 <= OFF;
			digit1 <= OFF;
			digit2 <= OFF;
			digit3 <= A;
		elsif current_state = errorState then
			next_state <= state0;
			digit0 <= OFF;
			digit1 <= r;
			digit2 <= r;
			digit3 <= E;
		else
			next_state <= state0;
		end if;
	end process;
	
end Behavioral;