library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity display_10base is
	port (
		price : in std_logic_vector(4 downto 0);
		coin_sum: in std_logic_vector(4 downto 0);
		seven_segment : out std_logic_vector (7 downto 0);
		digit_select : out std_logic_vector(3 downto 0);
		clk : in std_logic
	);
end display_10base;

architecture decoder of display_10base is
	signal selector, selector_next : std_logic_vector(1 downto 0);
	signal digit_temp : std_logic_vector(3 downto 0);
	signal digit0, digit2 : std_logic_vector(3 downto 0);
	signal digit1, digit3 : std_logic_vector(1 downto 0);
	signal price_low : std_logic_vector(3 downto 0);
	signal coin_low : std_logic_vector(3 downto 0);

begin
	selector_next <= selector + 1;
			
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
		if coin_sum >= 30 then
			digit3 <= "11";
			coin_low <= coin_sum - 30;
		elsif coin_sum >= 20 then
			digit3 <= "10";
			coin_low <= coin_sum - 20;
		elsif coin_sum >= 10 then
			digit3 <= "01";
			coin_low <= coin_sum - 10;
		else
			digit3 <= "00";
			coin_low <= coin_sum(3 downto 0);
		end if;
	end process;
	digit2 <= coin_low;
	
	process(price)
	begin
		if price >= 30 then
			digit1 <= "11";
			price_low <= price - 30;
		elsif price >= 20 then
			digit1 <= "10";
			price_low <= price - 20;
		elsif price >= 10 then
			digit1 <= "01";
			price_low <= price - 10;
		else
			digit1 <= "00";
			price_low <= price(3 downto 0);
		end if;
	end process;
	
	digit0 <= price_low;
	--decimal0 <= price mod 10;
	
	process(selector,digit0,digit1,digit2,digit3)
	begin
		if selector = "00" then
			digit_select <= "1110";
			digit_temp <= digit0;
		elsif selector = "01" then
			digit_select <= "1101";
			digit_temp <= "00" & digit1;
		elsif selector = "10" then
			digit_select <= "1011";
			digit_temp <= digit2;
		else
			digit_select <= "0111";
			digit_temp <= "00" & digit3;
		end if;	
	end process;
	
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
end decoder;