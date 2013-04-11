library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine_cpu is
	port(
		clk : in std_logic;
		reset : in std_logic;
		coin2 : in std_logic;
		coin5 : in std_logic;
		buy : in std_logic;
		price : in std_logic_vector(4 downto 0);
		sum : out std_logic_vector(4 downto 0);
		release_can : out std_logic;
		alarm : out std_logic
	);
end vending_machine_cpu;

architecture Behavioral of vending_machine_cpu is
	type state_type is (default_state, coin2_state, coin5_state, buy_state);
	signal current_state : state_type;
	signal next_state : state_type;
	signal sum_val, price_val : unsigned(4 downto 0);
	
begin
	sum <= std_logic_vector(sum_val);
	price_val <= unsigned(price);
	
	process(current_state,coin2,coin5,buy)
	begin
		next_state <= current_state;
		
		case current_state is
			when default_state =>
				if coin2 = '1' then
					next_state <= coin2_state;
				elsif coin5 = '1' then
					next_state <= coin5_state;
				elsif buy = '1' then
					next_state <= buy_state;
				end if;
			when coin2_state =>
				if coin2 = '0' then
					next_state <= default_state;
				end if;
			when coin5_state =>
				if coin5 = '0' then
					next_state <= default_state;
				end if;
			when buy_state =>
				if buy = '0' then
					next_state <= default_state;
				end if;
		end case;
	end process;
	
	process(current_state,clk, reset)
	begin
		if reset = '1' then
			current_state <= default_state;
			sum_val <= (others=>'0');
		elsif rising_edge(clk) then
			if next_state = coin2_state and current_state /= coin2_state then
				sum_val <= sum_val + 2;
			elsif next_state = coin5_state and current_state /= coin5_state then
				sum_val <= sum_val + 5;
			elsif next_state = buy_state and current_state /= buy_state then
				if sum_val >= price_val and price_val /= 0 then
					release_can <= '1';
					sum_val <= sum_val - price_val;
				else
					alarm <= '1';
				end if;
			elsif next_state = default_state then
				release_can <= '0';
				alarm <= '0';
			end if;			
			current_state <= next_state;
		end if;		
	end process;
	
end Behavioral;