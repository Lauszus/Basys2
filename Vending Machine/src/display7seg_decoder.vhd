library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity display is
port (
	price : in std_logic_vector (4 downto 0);
	seven_segment : out std_logic_vector (7 downto 0);
	digit_select : out std_logic_vector(3 downto 0);
	clk : in std_logic);
end display;

architecture decoder of display is
	component segment
	port(
		price : in std_logic_vector(3 downto 0);
		seven_segment : out std_logic_vector(7 downto 0)
		);
	end component;
	
	signal selector, selector_next : std_logic_vector(1 downto 0);
	signal priceHigh, digit_temp : std_logic_vector(3 downto 0);
	signal seven_segment1, seven_segment2: std_logic_vector(7 downto 0);

begin
	selector_next <= selector + 1;
	priceHigh <= "000" & price(4);
	digit_select <= digit_temp;
	
	Inst_segment1: segment port map (
		price => price(3 downto 0),
		seven_segment => seven_segment1
	);
	
	Inst_segment2: segment port map (
		price => priceHigh,
		seven_segment => seven_segment2
	);
	
	process(digit_temp)
	begin
		case digit_temp is
			when "1110" => seven_segment <= seven_segment1;
			when "1101" => seven_segment <= seven_segment2;
			when "1011" => seven_segment <= (others=>'1');
			when "0111" => seven_segment <= (others=>'1');
			when others => seven_segment <= (others=>'1');
		end case;
	end process;
	
	process(selector)
	begin
		case selector is
			when "00" => digit_temp <= "1110";
			when "01" => digit_temp <= "1101";
			when "10" => digit_temp <= "1011";
			when "11" => digit_temp <= "0111";
			when others => digit_temp <= (others=>'1');
		end case;
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