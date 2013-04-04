library ieee;
use ieee.std_logic_1164.all;

entity segment is
	port (
		price : in std_logic_vector (3 downto 0);
		seven_segment : out std_logic_vector (7 downto 0)
	);
end segment;

architecture Behavioral of segment is
	signal seven_segment_temp : std_logic_vector(7 downto 0);
	
begin
	seven_segment <= not seven_segment_temp;
	
	process(price)
	begin
		case price is
			when "0000" => seven_segment_temp <= "00111111";
			when "0001" => seven_segment_temp <= "00000110";
			when "0010" => seven_segment_temp <= "01011011";
			when "0011" => seven_segment_temp <= "01001111";
			when "0100" => seven_segment_temp <= "01100110";
			when "0101" => seven_segment_temp <= "01101101";
			when "0110" => seven_segment_temp <= "01111101";
			when "0111" => seven_segment_temp <= "00000111";
			when "1000" => seven_segment_temp <= "01111111";
			when "1001" => seven_segment_temp <= "01101111";
			when "1010" => seven_segment_temp <= "01110111";
			when "1011" => seven_segment_temp <= "01111100";
			when "1100" => seven_segment_temp <= "00111001";
			when "1101" => seven_segment_temp <= "01011110";
			when "1110" => seven_segment_temp <= "01111001";
			when "1111" => seven_segment_temp <= "01110001";
			when others => seven_segment_temp <= "00000000";
		end case;	
	end process;
end Behavioral;