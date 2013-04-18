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
		price : in std_logic_vector(5 downto 0);
		sum : out std_logic_vector(6 downto 0);
		release_can : out std_logic;
		alarm : out std_logic
	);
end vending_machine_cpu;

architecture Behavioral of vending_machine_cpu is
	type state_type is (default_state, coin2_state, coin5_state, wait_coin_state, wait_buy_state, buy_state, alarm_state);
	signal current_state, next_state : state_type;
	signal price_val : unsigned(5 downto 0);
	signal add_mux : std_logic_vector(1 downto 0);
	signal add_val : signed(7 downto 0);
	signal sum_val : signed(7 downto 0);
	
begin
	sum <= std_logic_vector(sum_val(6 downto 0));
	price_val <= unsigned(price);
	
	process(current_state,coin2,coin5,buy,price_val,sum_val)
	begin
		next_state <= current_state;
		
		case current_state is
			when default_state =>
				if coin2 = '1' then
					next_state <= coin2_state;
				elsif coin5 = '1' then
					next_state <= coin5_state;
				elsif buy = '1' then
					if unsigned(sum_val(6 downto 0)) >= price_val and price_val /= 0 then
						next_state <= buy_state;						
					else
						next_state <= alarm_state;											
					end if;
				end if;
			when coin2_state => next_state <= wait_coin_state;
			when coin5_state => next_state <= wait_coin_state;
			when buy_state => next_state <= wait_buy_state;
			when alarm_state => 
				if buy = '0' then
					next_state <= default_state;
				end if;
			when wait_coin_state =>
				if coin2 = '0' and coin5 = '0' then
					next_state <= default_state;
				end if;
			when wait_buy_state =>
				if buy = '0' then
					next_state <= default_state;
				end if;
			when others => next_state <= default_state;
		end case;
	end process;
	
	process(current_state)
	begin
		add_mux <= "00";
		alarm <= '0';
		release_can <= '0';
		case current_state is
			when default_state =>
				release_can <= '0';
				alarm <= '0';
			when coin2_state => add_mux <= "01";
			when coin5_state => add_mux <= "10";
			when buy_state => add_mux <= "11";
			when alarm_state => alarm <= '1';
			when wait_buy_state => release_can <= '1';
			when others =>
				release_can <= '0';
				alarm <= '0';
		end case;
	end process;
	
	process(add_mux,price_val)
	begin
		if add_mux = "01" then
			add_val <= "00000010"; -- 2
		elsif add_mux = "10" then
			add_val <= "00000101"; -- 5
		elsif add_mux = "11" then
			add_val <= signed("10" & price_val(5 downto 0)); -- Return the negative number of the price
		else
			add_val <= "00000000";
		end if;		
	end process;
	
	process(clk, reset)
	begin
		if reset = '1' then
			current_state <= default_state;
			sum_val <= (others=>'0');
		elsif rising_edge(clk) then
			current_state <= next_state;
			
			-- Vi vil gerne undskylde på forhånd for nedenstående kode :(
			if add_val < 0 then
				sum_val <= sum_val - add_val;
			else
				sum_val <= sum_val + add_val;
				if sum_val > 99 then
					sum_val <= sum_val - 100;
				end if;
			end if;
			--------------------------------------------------------------
			
		end if;
	end process;
	
end Behavioral;