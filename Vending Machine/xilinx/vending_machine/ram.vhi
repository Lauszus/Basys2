
-- VHDL Instantiation Created from source file ram.vhd -- 22:06:08 03/21/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT ram
	PORT(
		clk : IN std_logic;
		rd_addr : IN std_logic_vector(8 downto 0);
		wr_addr : IN std_logic_vector(8 downto 0);
		wr_data : IN std_logic_vector(7 downto 0);
		wr_ena : IN std_logic;          
		rd_data : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_ram: ram PORT MAP(
		clk => ,
		rd_addr => ,
		wr_addr => ,
		wr_data => ,
		wr_ena => ,
		rd_data => 
	);


