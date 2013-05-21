--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:30:20 05/21/2013
-- Design Name:   
-- Module Name:   C:/Users/Lauszus/Documents/GitHub/Basys2/VendingMachine/src/serial_interface_test.vhd
-- Project Name:  vending_machine
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: serial_interface
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY serial_interface_test IS
END serial_interface_test;
 
ARCHITECTURE behavior OF serial_interface_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT serial_interface
    PORT(
         clk_50 : IN  std_logic;
         reset : IN  std_logic;
         digit0 : IN  std_logic_vector(3 downto 0);
         digit1 : IN  std_logic_vector(3 downto 0);
         tx : OUT  std_logic;
         new_value : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_50 : std_logic := '0';
   signal reset : std_logic := '0';
   signal digit0 : std_logic_vector(3 downto 0) := (others => '0');
   signal digit1 : std_logic_vector(3 downto 0) := (others => '0');
   signal new_value : std_logic := '0';

 	--Outputs
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_50_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: serial_interface PORT MAP (
          clk_50 => clk_50,
          reset => reset,
          digit0 => digit0,
          digit1 => digit1,
          tx => tx,
          new_value => new_value
        );

   -- Clock process definitions
   clk_50_process :process
   begin
		clk_50 <= '0';
		wait for clk_50_period/2;
		clk_50 <= '1';
		wait for clk_50_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
      reset <= '1';
      wait for clk_50_period*10;
      reset <= '0';
      wait for clk_50_period*10;
      
      digit0 <= "0111";
      digit1 <= "0101";
      new_value <= '1';

      wait;
   end process;

END;
