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
	signal digit_out : std_logic_vector(3 downto 0);
	signal digit0, digit2, digit3 : std_logic_vector(3 downto 0);
	signal digit1 : std_logic_vector(2 downto 0);
	signal price_temp : std_logic_vector(6 downto 0);
	signal q1, q2 : std_logic_vector(7 downto 0);
	
	signal new_enable : std_logic;

-----------------------------------------------------------------------------
-- Binary to decimal converter
-- Used to convert price and coin sum into 10 base numbers
-----------------------------------------------------------------------------
	
	COMPONENT bcdtab
	PORT(
		address : IN std_logic_vector(6 downto 0);          
		q : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

-----------------------------------------------------------------------------
-- Serial interface (UART)
-- Used to write the value of coin sum when a new value is updated
-- Only transmit is implemented
-----------------------------------------------------------------------------
	
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

-----------------------------------------------------------------------------	

begin
	-- Serial interface interface
	Inst_serial_interface: serial_interface PORT MAP(
		clk_50 => clk_50,
		reset => reset,		
		digit0 => digit3,
		digit1 => digit2,
		tx => tx,
		new_value => new_enable -- When this goes high, the serial interface will send the coin sum
	);
	
	-- BCD instances
	Inst_bcdtab1: bcdtab PORT MAP(
		address => price_temp,
		q => q1
	);
	price_temp <= '0' & price;
	
	Inst_bcdtab2: bcdtab PORT MAP(
		address => coin_sum,
		q => q2
	);	
	
	-- Set the segments to the desired value
	process(digit_out)
	begin
		case digit_out is
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
	
	-- Used for the display multiplexing
	process(selector,digit0,digit1,digit2,digit3)
	begin
		if selector = "00" then
			digit_select <= "1110";
			digit_out <= digit0;
		elsif selector = "01" then
			digit_select <= "1101";
			digit_out <= '0' & digit1;
		elsif selector = "10" then
			digit_select <= "1011";
			digit_out <= digit2;
		else
			digit_select <= "0111";
			digit_out <= digit3;
		end if;	
	end process;
	
	-- This will update the segment selector and update the different 
	-- digits based on price and coin sum
	process(clk)
	begin
		if rising_edge(clk) then
			selector <= selector_next;
			digit0 <= q1(3 downto 0);
			digit1 <= q1(6 downto 4);
			digit2 <= q2(3 downto 0);
			digit3 <= q2(7 downto 4);
			
			-- Used to indicate when the computation is done and it is 
			-- okay for the serial interface to send the current coin sum
			if new_value = '1' then
				new_enable <= '1';
			else
				new_enable <= '0';
			end if;
		end if;
	end process;
	
	selector_next <= selector + 1;
	
end decoder;