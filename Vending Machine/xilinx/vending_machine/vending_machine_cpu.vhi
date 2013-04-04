
-- VHDL Instantiation Created from source file vending_machine_cpu.vhd -- 16:27:08 03/21/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT vending_machine_cpu
	PORT(
		reset : IN std_logic;
		coin2 : IN std_logic;
		coin5 : IN std_logic;
		buy : IN std_logic;
		price : IN std_logic_vector(4 downto 0);          
		sum : OUT std_logic_vector(4 downto 0);
		release_can : OUT std_logic;
		alarm : OUT std_logic
		);
	END COMPONENT;

	Inst_vending_machine_cpu: vending_machine_cpu PORT MAP(
		reset => ,
		coin2 => ,
		coin5 => ,
		buy => ,
		price => ,
		sum => ,
		release_can => ,
		alarm => 
	);


