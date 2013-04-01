Library ieee;
USE ieee.std_logic_1164.all;

entity adder3 is 
  Port (  A: in std_logic_vector(2 downto 0);
          B: in std_logic_vector(2 downto 0);
          CI: in std_logic;
          S: out std_logic_vector(2 downto 0);
          CO: out std_logic
        );
end adder3;

architecture funktion of adder3 is
  component full_adder
    port( A: in std_logic;
          B: in std_logic;
          C: in std_logic;
          S: out std_logic;
          T: out std_logic
        );
  end component;
  signal C0Temp: std_logic_vector(1 downto 0); 
  begin
    Add0: full_adder port map(A=>A(0),B=>B(0),C=>CI,S=>S(0),T=>C0Temp(0));
    Add1: full_adder port map(A=>A(1),B=>B(1),C=>C0Temp(0),S=>S(1),T=>C0Temp(1));
    Add2: full_adder port map(A=>A(2),B=>B(2),C=>C0Temp(1),S=>S(2),T=>CO);
end funktion;