
-- VHDL Instantiation Created from source file segment.vhd -- 17:06:40 10/14/2012
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT segment
	PORT(
		binary : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;          
		anodes : OUT std_logic_vector(1 downto 0);
		segment : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

	Inst_segment: segment PORT MAP(
		binary => ,
		anodes => ,
		segment => ,
		clk => 
	);


