
-- VHDL Instantiation Created from source file display.vhd -- 15:24:42 03/14/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT display
	PORT(
		binary_number : IN std_logic_vector(4 downto 0);
		clk : IN std_logic;          
		seven_segment : OUT std_logic_vector(7 downto 0);
		anode : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_display: display PORT MAP(
		binary_number => ,
		seven_segment => ,
		anode => ,
		clk => 
	);


