
-- VHDL Instantiation Created from source file input_sync.vhd -- 16:07:10 03/21/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT input_sync
	PORT(
		clk : IN std_logic;
		reset_in : IN std_logic;
		coin2_in : IN std_logic;
		coin5_in : IN std_logic;
		buy_in : IN std_logic;
		price_in : IN std_logic_vector(4 downto 0);          
		reset : OUT std_logic;
		coin2 : OUT std_logic;
		coin5 : OUT std_logic;
		buy : OUT std_logic;
		price : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;

	Inst_input_sync: input_sync PORT MAP(
		clk => ,
		reset_in => ,
		coin2_in => ,
		coin5_in => ,
		buy_in => ,
		price_in => ,
		reset => ,
		coin2 => ,
		coin5 => ,
		buy => ,
		price => 
	);


