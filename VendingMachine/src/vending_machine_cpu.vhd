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
		alarm : out std_logic;
		new_value : out std_logic
	);
end vending_machine_cpu;

architecture Behavioral of vending_machine_cpu is
	type state_type is (default_state, coin2_state, coin5_state, wait_coin_state, release_can_state, calc_state, buy_state, alarm_state);
	signal current_state, next_state : state_type;
	
	signal add_mux : std_logic_vector(1 downto 0);
	signal sum_enable, output_enable, negative : std_logic;
	signal price_val : unsigned(5 downto 0);
	signal sum_val, add_val : unsigned(6 downto 0);
	signal sum_val_temp, sum_val_new : signed(7 downto 0);
	
begin
	price_val <= unsigned(price);
	sum <= std_logic_vector(sum_val);
	
	-- Next state logic for the FSM
	process(current_state,coin2,coin5,buy,sum_val_new)
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
			when coin2_state => next_state <= wait_coin_state;
			when coin5_state => next_state <= wait_coin_state;
			when buy_state => next_state <= calc_state;
			when calc_state =>
				if sum_val_new < 0 then -- Check if the result is negative
					next_state <= alarm_state; -- If it is negative then it means that there is not enough money in order to buy the can
				else
					next_state <= release_can_state;
				end if;					
			when wait_coin_state =>
				if coin2 = '0' and coin5 = '0' then -- Wait until button is released
					next_state <= default_state;
				end if;
			when alarm_state => 
				if buy = '0' then -- Wait until button is released
					next_state <= default_state;
				end if;
			when release_can_state =>
				if buy = '0' then -- Wait until button is released
					next_state <= default_state;
				end if;
			when others => next_state <= default_state;
		end case;
	end process;
	
	-- State logic for the FSM
	process(current_state,sum_val,price_val)
	begin
		add_mux <= "00";
		alarm <= '0';
		release_can <= '0';
		output_enable <= '0';
		sum_enable <= '0';
		negative <= '0';
		
		case current_state is
			when coin2_state =>
				add_mux <= "01";
				output_enable <= '1';
			when coin5_state =>
				add_mux <= "10";
				output_enable <= '1';		
			when wait_coin_state => sum_enable <= '1';
			
			when buy_state =>
				add_mux <= "11";
				output_enable <= '1';
				negative <= '1';
			when alarm_state => alarm <= '1';
			when release_can_state =>
				sum_enable <= '1';
				release_can <= '1';
			
			when others =>
		end case;
	end process;
	
	-- We use a mux in order to select which value to add or subtract
	process(add_mux,price_val)
	begin		
		if add_mux = "01" then
			add_val <= "0000010"; -- 2
		elsif add_mux = "10" then
			add_val <= "0000101"; -- 5
		elsif add_mux = "11" then
			add_val <= '0' & price_val;			
		else
			add_val <= "0000000";
		end if;		
	end process;
	
	-- This adder will take the value selected by the mux and add or subtract in from the current coin sum
	process(add_val,sum_val,negative)
	begin
		if negative = '1' then
			sum_val_temp <= signed('0' & sum_val) - signed('0' & add_val);
		else
			if sum_val + add_val > 99 then
				sum_val_temp <= "01100011"; -- 99
			else
				sum_val_temp <= signed('0' & sum_val) + signed('0' & add_val);
			end if;
		end if;
	end process;
	
	process(clk, reset)
	begin
		if reset = '1' then
			current_state <= default_state;
			sum_val <= (others=>'0');
		elsif rising_edge(clk) then
			current_state <= next_state;
			if output_enable = '1' then
				sum_val_new <= sum_val_temp;
			end if;
			
			-- If this is high we will update the coin sum after we have made sure it is valid
			if sum_enable = '1' then
				sum_val <= unsigned(sum_val_new(6 downto 0));
				new_value <= '1'; -- Bit for the serial interface - used to indicate that a new value has been set
			else
				new_value <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;