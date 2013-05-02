library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity serial_interface is
	port (
		clk_50 : in std_logic; -- 50MHz clock
		reset : in std_logic;
		tx : out std_logic;
		--rx : in std_logic;
		outputBufer : in std_logic_vector(7 downto 0);
		--receiveBuffer : out std_logic_vector(7 downto 0);
		write_enable : in std_logic
	);
end serial_interface;

architecture Behavioral of serial_interface is
	type state_type is (state_idle, state_start, state0, state1, state2, state3, state4, state5, state6, state7, state_stop);
	signal current_state, next_state : state_type;
	
	signal cnt, cnt_reg : std_logic_vector(9 downto 0);
	signal serial_enable : std_logic;

begin
	process(clk_50,reset)
	begin
		if reset = '1' then
			cnt_reg <= (others => '0');
			current_state <= state_idle;
			tx <= '1';
		elsif rising_edge(clk_50) then
			cnt_reg <= cnt;
			if serial_enable = '1' then
				current_state <= next_state;
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
	
	process(current_state,write_enable)
	begin
		next_state <= current_state;
		
		case current_state is
			when state_idle =>
				if write_enable = '1' then
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
			when state_stop => next_state <= state_idle;
			when others => next_state <= state_idle;
		end case;
	end process;
	
	process(current_state,outputBufer) -- The output send the output as 8N1
	begin
		if current_state = state_idle then
			tx <= '1';
		elsif current_state = state_start then
			tx <= '0';
		elsif current_state = state0 then
			tx <= outputBufer(0);
		elsif current_state = state1 then
			tx <= outputBufer(1);
		elsif current_state = state2 then
			tx <= outputBufer(2);
		elsif current_state = state3 then
			tx <= outputBufer(3);
		elsif current_state = state4 then
			tx <= outputBufer(4);
		elsif current_state = state5 then
			tx <= outputBufer(5);
		elsif current_state = state6 then
			tx <= outputBufer(6);
		elsif current_state = state7 then
			tx <= outputBufer(7);
		elsif current_state = state_stop then
			tx <= '1';
		else			
			tx <= '1';
		end if;
	end process;
	
end Behavioral;