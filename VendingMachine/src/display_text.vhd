library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity display_text is
	port(
		clk : in std_logic;
		reset : in std_logic;
		seven_segment : out std_logic_vector (7 downto 0);
		digit_select : out std_logic_vector(3 downto 0);
		release_can : in std_logic;
		alarm : in std_logic;
		flavor : in std_logic
	);
end display_text;

architecture Behavioral of display_text is
	-- State signals
	type state_type is (state0, state1, state2, state3, state4, state5, state6, state7, state8, error_state);
	signal current_state, next_state : state_type;
	
	-- Used to scroll the text slowly across the segments
	signal cnt, cnt_reg : std_logic_vector(7 downto 0);
	signal display_enable : std_logic;
	
	signal segment_selector, segment_selector_next : std_logic_vector(1 downto 0);
	signal digit0, digit1, digit2, digit3 : std_logic_vector(7 downto 0);
	
	-- These constants are used to write letters to the seven segment display
	constant OFF : std_logic_vector(7 downto 0) := "11111111";
	constant C : std_logic_vector(7 downto 0) := "11000110";
	constant O : std_logic_vector(7 downto 0) := "11000000";
	constant L : std_logic_vector(7 downto 0) := "11000111";
	constant A : std_logic_vector(7 downto 0) := "10001000";
	constant E : std_logic_vector(7 downto 0) := "10000110";
	constant r : std_logic_vector(7 downto 0) := "10101111";
	constant P : std_logic_vector(7 downto 0) := "10001100";
	constant S : std_logic_vector(7 downto 0) := "10010010";
	constant I : std_logic_vector(7 downto 0) := "11001111";

begin
	segment_selector_next <= segment_selector + 1;
	
	process(clk,reset)
	begin
		if reset = '1' then
			cnt_reg <= (others => '0');
			current_state <= state0;
		elsif rising_edge(clk) then
			cnt_reg <= cnt;
			segment_selector <= segment_selector_next;
			if display_enable = '1' then
				current_state <= next_state;
			end if;
		end if;
	end process;
	
	-- This will control the multiplexing of the display
	process(segment_selector,digit0,digit1,digit2,digit3)
	begin
		if segment_selector = "00" then
			digit_select <= "1110";
			seven_segment <= digit0;
		elsif segment_selector = "01" then
			digit_select <= "1101";
			seven_segment <= digit1;
		elsif segment_selector = "10" then
			digit_select <= "1011";
			seven_segment <= digit2;
		else
			digit_select <= "0111";
			seven_segment <= digit3;
		end if;	
	end process;
	
	-- This will generate an enable signal with a frequency of 3.81 Hz
	-- This will ensure that the text is scrolled nice and slowly
	process(cnt_reg)
	begin
		display_enable <= '0';
		if cnt_reg = 200 then
			cnt <= (others => '0');
			display_enable <= '1';
		else
			cnt <= cnt_reg + 1;
		end if;
	end process;
	
	-- Next state logic for the FSM
	process(current_state,alarm,release_can,flavor)
	begin
		next_state <= current_state;
		
		if alarm = '1' then
			next_state <= error_state; -- If alarm is high we will print Err on the display
		elsif release_can = '0' then
			next_state <= state0; -- Start the scrolling sequence
		else
			case current_state is
				when state0 => next_state <= state1;
				when state1 => next_state <= state2;
				when state2 => next_state <= state3;
				when state3 => next_state <= state4;
				when state4 => next_state <= state5;
				when state5 => next_state <= state6;
				when state6 => next_state <= state7;
				when state7 =>
					if flavor = '0' then
						next_state <= state0;
					else
						next_state <= state8; -- Since COLA and PEPSI are not equal length we need one more state to write PEPSI
					end if;
				when state8 => next_state <= state0;
				when error_state => next_state <= state0;
				when others => next_state <= state0;
			end case;
		end if;
	end process;
	
	-- State logic for the FSM
	-- This will set the different digits depending on the state
	process(current_state,flavor)
	begin
		if current_state = state0 then
			digit0 <= OFF;
			digit1 <= OFF;
			digit2 <= OFF;
			digit3 <= OFF;
		elsif current_state = state1 then
			if flavor = '0' then
				digit0 <= C;
			else
				digit0 <= P;
			end if;
			digit1 <= OFF;
			digit2 <= OFF;
			digit3 <= OFF;
		elsif current_state = state2 then
			if flavor = '0' then
				digit0 <= O;
				digit1 <= C;
			else
				digit0 <= E;
				digit1 <= P;
			end if;
			digit2 <= OFF;
			digit3 <= OFF;
		elsif current_state = state3 then
			if flavor = '0' then
				digit0 <= L;
				digit1 <= O;
				digit2 <= C;
			else
				digit0 <= P;
				digit1 <= E;
				digit2 <= P;
			end if;
			digit3 <= OFF;
		elsif current_state = state4 then
			if flavor = '0' then
				digit0 <= A;
				digit1 <= L;
				digit2 <= O;
				digit3 <= C;
			else
				digit0 <= S;
				digit1 <= P;
				digit2 <= E;
				digit3 <= P;
			end if;
		elsif current_state = state5 then
			if flavor = '0' then
				digit0 <= OFF;
				digit1 <= A;
				digit2 <= L;
				digit3 <= O;
			else
				digit0 <= I;
				digit1 <= S;
				digit2 <= P;
				digit3 <= E;			
			end if;
		elsif current_state = state6 then
			digit0 <= OFF;
			if flavor = '0' then
				digit1 <= OFF;
				digit2 <= A;
				digit3 <= L;
			else
				digit1 <= I;
				digit2 <= S;
				digit3 <= P;			
			end if;
		elsif current_state = state7 then			
			digit0 <= OFF;
			digit1 <= OFF;
			if flavor = '0' then
				digit2 <= OFF;
				digit3 <= A;
			else
				digit2 <= I;
				digit3 <= S;			
			end if;
		elsif current_state = state8 then			
			digit0 <= OFF;
			digit1 <= OFF;
			digit2 <= OFF;
			digit3 <= I;
		elsif current_state = error_state then
			digit0 <= OFF;
			digit1 <= r;
			digit2 <= r;
			digit3 <= E;
		else			
			digit0 <= OFF;
			digit1 <= OFF;
			digit2 <= OFF;
			digit3 <= OFF;
		end if;
	end process;
	
end Behavioral;