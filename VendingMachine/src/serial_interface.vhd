library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity serial_interface is
	port (
		clk_50 : in std_logic; -- 50MHz clock
		reset : in std_logic;
		tx : out std_logic;
		digit0 : in std_logic_vector(3 downto 0);
		digit1 : in std_logic_vector(3 downto 0);
		--rx : in std_logic;
		--receiveBuffer : out std_logic_vector(7 downto 0);
		new_value : in std_logic
	);
end serial_interface;

architecture Behavioral of serial_interface is
	type state_type is (state_idle, state_wait, state_start, state0, state1, state2, state3, state4, state5, state6, state7, state_stop, state_digit_check, state_digit_increment, state_digit_increment_stop);
	signal current_state, next_state : state_type;
	
	signal cnt, cnt_reg : std_logic_vector(9 downto 0);
	signal serial_enable : std_logic;
	
	signal digit, digit_next : std_logic_vector(1 downto 0);
	signal digit_enable : std_logic;
	constant CR : std_logic_vector(3 downto 0) := "1101"; -- Carriage return
	constant LF : std_logic_vector(3 downto 0) := "1010"; -- Line feed
	
	signal wait_counter, wait_counter_next : std_logic_vector(19 downto 0);
	signal wait_enable : std_logic;
	
begin
	digit_next <= digit + 1;
	wait_counter_next <= wait_counter + 1;
	
	process(clk_50,reset)
	begin
		if reset = '1' then
			cnt_reg <= (others => '0');
			current_state <= state_idle;
		elsif rising_edge(clk_50) then
			cnt_reg <= cnt;
			if serial_enable = '1' then
				current_state <= next_state;
			end if;
			if digit_enable = '1' then
				digit <= digit_next;
			end if;
			if wait_enable = '1' then
				wait_counter <= wait_counter_next;
			else
				wait_counter <= (others => '0');
			end if;
		end if;
	end process;
	
	process(cnt_reg)
	begin
		serial_enable <= '0';
		if cnt_reg = 434 then -- Set the baudrate to 115200 (50MHz/115200=434)
			cnt <= (others => '0');
			serial_enable <= '1';
		else
			cnt <= cnt_reg + 1;
		end if;
	end process;
	
	process(current_state,new_value,digit,wait_counter)
	begin
		next_state <= current_state;		
		
		case current_state is
			when state_idle =>
				if new_value = '1' then
					next_state <= state_wait;
				end if;
			when state_wait => -- This state is used since we need to wait just a short while until the computation of digit0 and digit1 is done in "display_10base"
				if wait_counter(19) = '1' then
					next_state <= state_start;
				end if;
			when state_start => next_state <= state0;
			when state0 => next_state <= state1;
			when state1 => next_state <= state2;
			when state2 => next_state <= state3;
			when state3 => next_state <= state4;
			when state4 => next_state <= state5;
			when state5 => next_state <= state6;
			when state6 => next_state <= state7;
			when state7 => next_state <= state_stop;
			when state_stop => next_state <= state_digit_check;
			when state_digit_check =>
				if digit = "11" then -- Check if we have send all characters
					if new_value = '0' then -- Wait until the button is released
						next_state <= state_digit_increment_stop;
					end if;
				else
					next_state <= state_digit_increment;
				end if;
			when state_digit_increment => next_state <= state_start;
			when state_digit_increment_stop => next_state <= state_idle;
			when others => next_state <= state_idle;
		end case;
	end process;
	
	process(current_state,digit,digit0,digit1) -- The output send the output as 8N1
	begin
		digit_enable <= '0';
		wait_enable <= '0';
		tx <= '1'; -- The start bit sets TX low after that we simply write the byte and set TX high again
		
		if current_state = state_wait then
			wait_enable <= '1';
		elsif current_state = state_start then
			tx <= '0'; -- Set TX low to indicate that we want to send a new byte
		elsif current_state = state0 then
			if digit = "00" then
				tx <= digit0(0);
			elsif digit = "01" then
				tx <= digit1(0);
			elsif digit = "10" then
				tx <= CR(0);
			else
				tx <= LF(0);
			end if;
		elsif current_state = state1 then
			if digit = "00" then
				tx <= digit0(1);
			elsif digit = "01" then
				tx <= digit1(1);
			elsif digit = "10" then
				tx <= CR(1);
			else
				tx <= LF(1);
			end if;
		elsif current_state = state2 then
			if digit = "00" then
				tx <= digit0(2);
			elsif digit = "01" then
				tx <= digit1(2);
			elsif digit = "10" then
				tx <= CR(2);
			else
				tx <= LF(2);
			end if;
		elsif current_state = state3 then
			if digit = "00" then
				tx <= digit0(3);
			elsif digit = "01" then
				tx <= digit1(3);
			elsif digit = "10" then
				tx <= CR(3);
			else
				tx <= LF(3);
			end if;
		elsif current_state = state4 then
			if digit = "00" or digit = "01" then
				tx <= '1'; -- Convert to ASCII
			else
				tx <= '0';
			end if;
		elsif current_state = state5 then
			if digit = "00" or digit = "01" then
				tx <= '1'; -- Convert to ASCII
			else
				tx <= '0';
			end if;
		elsif current_state = state6 then
			tx <= '0';
		elsif current_state = state7 then
			tx <= '0';
		elsif current_state = state_stop then
			tx <= '1'; -- Set it high again after the transfer
		elsif current_state = state_digit_increment then
			digit_enable <= '1'; -- This will increment "digit"
		elsif current_state = state_digit_increment_stop then
			digit_enable <= '1'; -- This will increment "digit"
		end if;
	end process;
	
end Behavioral;