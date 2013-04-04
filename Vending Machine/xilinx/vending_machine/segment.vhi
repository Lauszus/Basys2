
-- VHDL Instantiation Created from source file segment.vhd -- 16:02:41 03/14/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT segment
	PORT(
		price : IN std_logic_vector(4 downto 0);          
		seven_segment : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_segment: segment PORT MAP(
		price => ,
		seven_segment => 
	);


