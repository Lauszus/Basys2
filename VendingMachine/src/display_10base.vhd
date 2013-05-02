library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity display_10base is
	port (
		clk_50 : in std_logic; -- 50MHz clock
		reset : in std_logic;
		tx : out std_logic;
		--rx : in std_logic;
		--receiveBuffer : out std_logic_vector(7 downto 0);
		price : in std_logic_vector(5 downto 0);
		coin_sum: in std_logic_vector(6 downto 0);
		seven_segment : out std_logic_vector (7 downto 0);
		digit_select : out std_logic_vector(3 downto 0);
		clk : in std_logic;
		new_value : in std_logic
	);
end display_10base;

architecture decoder of display_10base is
	signal selector, selector_next : std_logic_vector(1 downto 0);
	signal digit_temp : std_logic_vector(3 downto 0);
	signal digit0 : std_logic_vector(5 downto 0);
	signal digit1 : std_logic_vector(2 downto 0);
	signal digit2 : std_logic_vector(6 downto 0);
	signal digit3 : std_logic_vector(3 downto 0);
	signal price_subtract : std_logic_vector(5 downto 0);
	signal coin_subtract : std_logic_vector(6 downto 0);
	
	COMPONENT serial_interface
	PORT(
		clk_50 : IN std_logic;
		reset : IN std_logic;
		digit0 : IN std_logic_vector(3 downto 0);
		digit1 : IN std_logic_vector(3 downto 0);
		new_value : IN std_logic;          
		tx : OUT std_logic
		);
	END COMPONENT;
	
begin
	Inst_serial_interface: serial_interface PORT MAP(
		clk_50 => clk_50,
		reset => reset,
		tx => tx,
		digit0 => digit3(3 downto 0),
		digit1 => digit2(3 downto 0),
		new_value => new_value
	);
	
	process(digit_temp)
	begin
		case digit_temp is
			when "0000" => seven_segment <= "11000000";
			when "0001" => seven_segment <= "11111001";
			when "0010" => seven_segment <= "10100100";
			when "0011" => seven_segment <= "10110000";
			when "0100" => seven_segment <= "10011001"; 
			when "0101" => seven_segment <= "10010010";
			when "0110" => seven_segment <= "10000010";
			when "0111" => seven_segment <= "11111000";
			when "1000" => seven_segment <= "10000000";
			when "1001" => seven_segment <= "10010000";
			when others => seven_segment <= (others=>'1');
		end case;
	end process;
	
	process(coin_sum)
	begin
		if coin_sum >= 90 then
			digit3 <= "1001";
			coin_subtract <= "1011010"; -- 90
		elsif coin_sum >= 80 then
			digit3 <= "1000";
			coin_subtract <= "1010000"; -- 80
		elsif coin_sum >= 70 then
			digit3 <= "0111";
			coin_subtract <= "1000110"; -- 70
		elsif coin_sum >= 60 then
			digit3 <= "0110";
			coin_subtract <= "0111100"; -- 60
		elsif coin_sum >= 50 then
			digit3 <= "0101";
			coin_subtract <= "0110010"; -- 50
		elsif coin_sum >= 40 then
			digit3 <= "0100";
			coin_subtract <= "0101000"; -- 40
		elsif coin_sum >= 30 then
			digit3 <= "0011";
			coin_subtract <= "0011110"; -- 30
		elsif coin_sum >= 20 then
			digit3 <= "0010";
			coin_subtract <= "0010100"; -- 20
		elsif coin_sum >= 10 then
			digit3 <= "0001";
			coin_subtract <= "0001010"; -- 10
		else
			digit3 <= "0000";
			coin_subtract <= (others=>'0');
		end if;
	end process;
	digit2 <= coin_sum - coin_subtract;
	
	process(price)
	begin
		if price >= 60 then
			digit1 <= "110";
			price_subtract <= "111100"; -- 60
		elsif price >= 50 then
			digit1 <= "101";
			price_subtract <= "110010"; -- 50
		elsif price >= 40 then
			digit1 <= "100";
			price_subtract <= "101000"; -- 40
		elsif price >= 30 then
			digit1 <= "011";
			price_subtract <= "011110"; -- 30
		elsif price >= 20 then
			digit1 <= "010";
			price_subtract <= "010100"; -- 20
		elsif price >= 10 then
			digit1 <= "001";
			price_subtract <= "001010"; -- 10
		else
			digit1 <= "000";
			price_subtract <= (others=>'0');
		end if;
	end process;
	digit0 <= price - price_subtract;
	
	process(selector,digit0,digit1,digit2,digit3)
	begin
		if selector = "00" then
			digit_select <= "1110";
			digit_temp <= digit0(3 downto 0);
		elsif selector = "01" then
			digit_select <= "1101";
			digit_temp <= '0' & digit1(2 downto 0);
		elsif selector = "10" then
			digit_select <= "1011";
			digit_temp <= digit2(3 downto 0);
		else
			digit_select <= "0111";
			digit_temp <= digit3(3 downto 0);
		end if;	
	end process;
	
	selector_next <= selector + 1;
	
	process(clk)
	begin
		if rising_edge(clk) then
			selector <= selector_next;
		end if;
	end process;
end decoder;