
-- VHDL Instantiation Created from source file display7seg_decoder.vhd -- 14:30:24 03/14/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT display7seg_decoder
	PORT(
		binary_number : IN std_logic_vector(4 downto 0);          
		seg : OUT std_logic_vector(6 downto 0);
		an : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_display7seg_decoder: display7seg_decoder PORT MAP(
		binary_number => ,
		seg => ,
		an => 
	);


