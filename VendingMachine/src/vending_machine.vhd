------------------------------------------------------------------------
-- Top component of the vending machine for the course:
-- 02139 Digital electronics 2 at the Technical University of Denmark
-- This component declares and instantiates all the components of the
-- vending machine.
--
-- Created by Mads Bornebusch and Kristian Lauszus
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity vending_machine is
	port (
		clk_50        : in  std_logic; -- 50MHz clock
		clk_man       : in  std_logic; -- Button used for manual clock
		sel_man       : in  std_logic; -- Switch used to select between manual and onboard clock
		reset         : in  std_logic; -- Switch used to reset
		coin2         : in  std_logic; -- Button used to indicate that a 2 coins has been inserted
		coin5         : in  std_logic; -- Button used to indicate that a 5 coins has been inserted
		buy           : in  std_logic; -- Button used to buy a can
		price         : in  std_logic_vector(5 downto 0); -- Switches used to set the price of the can
		release_can   : out std_logic; -- Led used to indicate that a can is now released
		alarm         : out std_logic; -- Alarm used to indicate that there was not enough money in order to buy the can
		seven_segment : out std_logic_vector(7 downto 0); -- Cathodes for the segments
		digit_select  : out std_logic_vector(3 downto 0); -- Anodes for the segments
		tx            : out  std_logic -- TX for the UART
	);
end vending_machine;

architecture struct of vending_machine is
	signal clk            : std_logic; -- 763 Hz clock output from clock manager
	signal sync_reset     : std_logic; -- Reset switch after input synchronizer
	signal sync_coin2     : std_logic; -- 2 coin button after input synchronizer
	signal sync_coin5     : std_logic; -- 5 coin button after input synchronizer
	signal sync_buy       : std_logic; -- Buy button after input synchronizer
	signal sync_price : std_logic_vector(5 downto 0); -- Price switches after input synchronizer
	signal sum            : std_logic_vector(6 downto 0); -- Coin sum calculated in vending machine cpu
	
	signal release_can_var, alarm_var : std_logic; -- Internal release can and alarm signals
	signal new_value : std_logic; -- Used to indicate when a new value has been set, either by buying a can or by inserting a coin

-----------------------------------------------------------------------------
-- Clock divider component declaration
-- Used to generate the clock
-----------------------------------------------------------------------------
  
	component clock_manager
	port(
		clk_50   :  in  std_logic;
		clk_man  :  in  std_logic;
		sel_man  :  in  std_logic;
		clk      :  out std_logic
		);
	end component;

-----------------------------------------------------------------------------
-- Input synchronizer
-- Synchronize external inputs with the clock in order to avoid metastability
-----------------------------------------------------------------------------

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
	
-----------------------------------------------------------------------------
-- Vending machine cpu
-----------------------------------------------------------------------------
	
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

-----------------------------------------------------------------------------
-- Display manager
-- Controls the display
-- Writes the current price and coin sum
-- Will scroll COLA or PEPSI and a new can is bought or Err if alarm is high
-----------------------------------------------------------------------------
	
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

-----------------------------------------------------------------------------
  
begin
	-- The clock manager instance
	Inst_clock_manager : clock_manager port map (
		clk_50  => clk_50,
		clk_man => clk_man,
		sel_man => sel_man,
		clk => clk
	);
	
	-- Input synchronizer instance
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
		price => sync_price
	);
	
	-- Vending machine cpu instance
	Inst_vending_machine_cpu: vending_machine_cpu PORT MAP(
		clk => clk,
		reset => sync_reset,
		coin2 => sync_coin2,
		coin5 => sync_coin5,
		buy => sync_buy,
		price => sync_price,
		sum => sum,
		release_can => release_can_var,
		alarm => alarm_var,
		new_value => new_value
	);	
	
	-- Display manager instance
	Inst_display_manager: display_manager PORT MAP(
		clk_50 => clk_50,
		clk => clk,
		reset => sync_reset,
		price => sync_price,
		buy => sync_buy,
		seven_segment => seven_segment,
		digit_select => digit_select,
		coin_sum => sum,
		release_can => release_can_var,
		alarm => alarm_var,
		new_value => new_value,
		tx => tx
	);
	
	alarm <= alarm_var;
	release_can <= release_can_var;

------------------------------------------------------------------------
end struct;