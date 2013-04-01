library ieee;
use ieee.std_logic_1164.all;

entity adder3bit_segment is
	port(
		anodes: out std_logic_vector(3 downto 0);
		segments: out std_logic_vector(6 downto 0);
		clk : in std_logic;
		A: in std_logic_vector(2 downto 0);
		B: in std_logic_vector(2 downto 0);
		CI: in std_logic;
		S: out std_logic_vector(2 downto 0);
      CO: out std_logic
		);
end adder3bit_segment;

architecture Behavioral of adder3bit_segment is
	COMPONENT segment
		PORT(
			binary : IN std_logic_vector(3 downto 0);
			clk : IN std_logic;          
			anodes : OUT std_logic_vector(3 downto 0);
			segments : OUT std_logic_vector(6 downto 0)
			);
	END COMPONENT;
	COMPONENT adder3
	PORT(
		A : IN std_logic_vector(2 downto 0);
		B : IN std_logic_vector(2 downto 0);
		CI : IN std_logic;          
		S : OUT std_logic_vector(2 downto 0);
		CO : OUT std_logic
		);
	END COMPONENT;
	signal binaryOutput: std_logic_vector(3 downto 0);
begin
	inst_adder3: adder3 port map(A => A,B => B,CI => CI,S => binaryOutput(2 downto 0),CO => binaryOutput(3));
	inst_segment: segment port map(binary => binaryOutput,anodes => anodes,segments => segments,clk => clk);
	S <= binaryOutput(2 downto 0);
	CO <= binaryOutput(3);
end Behavioral;

