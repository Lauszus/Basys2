library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity segment is
	port (
		binary: in std_logic_vector(3 downto 0);
		anodes: out std_logic_vector(3 downto 0);
		segments: out std_logic_vector(6 downto 0);
		clk : in std_logic
	);
end segment;

architecture Behavioral of segment is
	signal decimal1: std_logic_vector(3 downto 0); 
	signal decimal2: std_logic;
	signal prescaler: std_logic_vector(18 downto 0);
	signal selector: std_logic;
	signal segmentsTemp: std_logic_vector(6 downto 0);
begin
	decimal1 <= "0000" when binary = "1010" else
					"0001" when binary = "1011" else
					"0010" when binary = "1100" else
					"0011" when binary = "1101" else
					"0100" when binary = "1110" else
					"0101" when binary = "1111" else
					binary;
					
	decimal2 <= '0' when binary < 10 else
					'1';
	
	process(clk) 
	begin
		if rising_edge(clk) then
			--if prescaler < "1100101101110011010" then -- equal to 120Hz
			if prescaler < "1001110001000" then -- equal to 10kHz			
				prescaler <= prescaler + 1;
			else
				selector <= not selector;	
				prescaler <= (others=>'0');
			end if;			
		end if;		
	end process;	
	
	anodes <= "0111" when selector = '0' else -- anodes are active low
				 "1011";
	segmentsTemp <= "0111111" when (selector = '0' and decimal1 = "0000") or (selector = '1' and decimal2 = '0')  else
				       "0000110" when (selector = '0' and decimal1 = "0001") or (selector = '1' and decimal2 = '1') else
				       "1011011" when selector = '0' and decimal1 = "0010" else
				       "1001111" when selector = '0' and decimal1 = "0011" else		  
				       "1100110" when selector = '0' and decimal1 = "0100" else
				       "1101101" when selector = '0' and decimal1 = "0101" else
				       "1111101" when selector = '0' and decimal1 = "0110" else
				       "0000111" when selector = '0' and decimal1 = "0111" else
				       "1111111" when selector = '0' and decimal1 = "1000" else
				       "1101111" when selector = '0' and decimal1 = "1001";
	segments <= not segmentsTemp;
end Behavioral;

