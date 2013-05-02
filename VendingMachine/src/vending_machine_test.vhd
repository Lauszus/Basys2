--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:14:08 04/25/2013
-- Design Name:   
-- Module Name:   C:/Users/Lauszus/Documents/GitHub/Basys2/Vending Machine/src/vending_machine_test.vhd
-- Project Name:  vending_machine
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vending_machine
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY vending_machine_test IS
END vending_machine_test;

ARCHITECTURE behavior OF vending_machine_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vending_machine
    PORT(
         clk_50 : IN  std_logic;
         clk_man : IN  std_logic;
         sel_man : IN  std_logic;
         reset : IN  std_logic;
         coin2 : IN  std_logic;
         coin5 : IN  std_logic;
         buy : IN  std_logic;
         price : IN  std_logic_vector(5 downto 0);
         release_can : OUT  std_logic;
         alarm : OUT  std_logic;
         seven_segment : OUT  std_logic_vector(7 downto 0);
         digit_select : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_50 : std_logic := '0';
   signal clk_man : std_logic := '0';
   signal sel_man : std_logic := '1';
   signal reset : std_logic := '0';
   signal coin2 : std_logic := '0';
   signal coin5 : std_logic := '0';
   signal buy : std_logic := '0';
   signal price : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal release_can : std_logic;
   signal alarm : std_logic;
   signal seven_segment : std_logic_vector(7 downto 0);
   signal digit_select : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_50_period : time := 10 ns;
   constant clk_man_period : time := 10 ns;
	--constant clk_period : time := 1312 us;
	--constant display_enable_period : time := clk_period*200;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vending_machine PORT MAP (
          clk_50 => clk_50,
          clk_man => clk_man,
          sel_man => sel_man,
          reset => reset,
          coin2 => coin2,
          coin5 => coin5,
          buy => buy,
          price => price,
          release_can => release_can,
          alarm => alarm,
          seven_segment => seven_segment,
          digit_select => digit_select
        );

   -- Clock process definitions
   clk_50_process :process
   begin
		clk_50 <= '0';
		wait for clk_50_period/2;
		clk_50 <= '1';
		wait for clk_50_period/2;
   end process;
 
   clk_man_process :process
   begin
		clk_man <= '0';
		wait for clk_man_period/2;
		clk_man <= '1';
		wait for clk_man_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;

      --wait for clk_50_period*10;
		
		reset <= '1';
		wait for clk_50_period*5;
		reset <= '0';
		wait for clk_50_period*5;
		
      -- insert stimulus here
		price <= "000111";
		wait for clk_50_period*5;
		buy <= '1';
		wait for clk_50_period*5;
		assert alarm = '0' report "error: alarm should be 1";
		buy <= '0';
		
		coin2 <= '1';
		wait for clk_50_period*5;
		coin2 <= '0';
		wait for clk_50_period*5;
		coin5 <= '1';
		wait for clk_50_period*5;
		coin5 <= '0';
		buy <= '1';
		wait for clk_50_period*5;
		assert release_can = '0' report "error: release_can should be 1";
		
      wait;
   end process;

--   signal reset : std_logic := '0';
--   signal coin2 : std_logic := '0';
--   signal coin5 : std_logic := '0';
--   signal buy : std_logic := '0';
--   signal price : std_logic_vector(5 downto 0) := (others => '0');
--
-- 	--Outputs
--   signal release_can : std_logic;
--   signal alarm : std_logic;
--   signal seven_segment : std_logic_vector(7 downto 0);
--   signal digit_select : std_logic_vector(3 downto 0);

END;