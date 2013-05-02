------------------------------------------------------------------------
-- Top component of the vending machine for the course:
-- 02139 Digital electronics 2 at the Technical University of Denmark
--
-- in this component declares and instantiates all the components of the
-- vending machine.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity vending_machine is
	port (
		clk_50        : in  std_logic;
		clk_man       : in  std_logic;
		sel_man       : in  std_logic;
		reset         : in  std_logic;
		coin2         : in  std_logic;
		coin5         : in  std_logic;
		buy           : in  std_logic;
		price         : in  std_logic_vector(5 downto 0);
		release_can   : out std_logic;
		alarm         : out std_logic;
		seven_segment : out std_logic_vector(7 downto 0);
		digit_select  : out std_logic_vector(3 downto 0);
		--rx            : in  std_logic;
		tx            : out  std_logic
	);

end vending_machine;

architecture struct of vending_machine is
	signal clk            : std_logic;
	signal sync_reset     : std_logic;
	signal sync_coin2     : std_logic;
	signal sync_coin5     : std_logic;
	signal sync_buy       : std_logic;
	signal sum            : std_logic_vector(6 downto 0);
	signal internal_price : std_logic_vector(5 downto 0);
	
	signal release_can_var, alarm_var : std_logic;
	signal new_value : std_logic;

------------------------------------------------------------------------
-- Clock divider component declaration
------------------------------------------------------------------------
  
	component clock_manager
	port(
		clk_50   :  in  std_logic;
		clk_man  :  in  std_logic;
		sel_man  :  in  std_logic;
		clk      :  out std_logic
		);
	end component;

------------------------------------------------------------------------
-- Complete the remaining three component declarations
------------------------------------------------------------------------

	COMPONENT input_sync
	PORT(
		clk : IN std_logic;
		reset_in : IN std_logic;
		coin2_in : IN std_logic;
		coin5_in : IN std_logic;
		buy_in : IN std_logic;
		price_in : IN std_logic_vector(5 downto 0);          
		reset : OUT std_logic;
		coin2 : OUT std_logic;
		coin5 : OUT std_logic;
		buy : OUT std_logic;
		price : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;	
	
	COMPONENT vending_machine_cpu
	PORT(
		clk : in std_logic;
		reset : IN std_logic;
		coin2 : IN std_logic;
		coin5 : IN std_logic;
		buy : IN std_logic;
		price : IN std_logic_vector(5 downto 0);
		sum : OUT std_logic_vector(6 downto 0);
		release_can : OUT std_logic;
		alarm : OUT std_logic;
		new_value : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT display_manager
	PORT(
		clk_50 : IN std_logic;
		clk : IN std_logic;
		reset : IN std_logic;
		price : IN std_logic_vector(5 downto 0);
		coin_sum : IN std_logic_vector(6 downto 0);
		buy : IN std_logic;
		release_can : IN std_logic;
		alarm : IN std_logic;          
		tx : OUT std_logic;
		seven_segment : OUT std_logic_vector(7 downto 0);
		digit_select : OUT std_logic_vector(3 downto 0);
		new_value : IN std_logic
		);
	END COMPONENT;

------------------------------------------------------------------------
  
begin  -- struct

	Inst_clock_manager : clock_manager port map (
		clk_50  => clk_50,
		clk_man => clk_man,
		sel_man => sel_man,
		clk => clk
	);

------------------------------------------------------------------------
-- Complete the remaining three component instantiations
------------------------------------------------------------------------
	
	Inst_input_sync: input_sync PORT MAP(
		clk => clk,
		reset_in => reset,
		coin2_in => coin2,
		coin5_in => coin5,
		buy_in => buy,
		price_in => price,
		reset => sync_reset,
		coin2 => sync_coin2,
		coin5 => sync_coin5,
		buy => sync_buy,
		price => internal_price
	);
		
	Inst_vending_machine_cpu: vending_machine_cpu PORT MAP(
		clk => clk,
		reset => sync_reset,
		coin2 => sync_coin2,
		coin5 => sync_coin5,
		buy => sync_buy,
		price => internal_price,
		sum => sum,
		release_can => release_can_var,
		alarm => alarm_var,
		new_value => new_value
	);	
	
	Inst_display_manager: display_manager PORT MAP(
		clk_50 => clk_50,
		clk => clk,
		reset => sync_reset,
		tx => tx,
		price => internal_price,
		coin_sum => sum,
		seven_segment => seven_segment,
		digit_select => digit_select,
		buy => sync_buy,
		release_can => release_can_var,
		alarm => alarm_var,
		new_value => new_value
	);
	
	alarm <= alarm_var;
	release_can <= release_can_var;

------------------------------------------------------------------------
end struct;