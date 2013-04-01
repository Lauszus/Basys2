Library ieee;
USE ieee.std_logic_1164.all;

entity full_adder is 
  Port (  A: in std_logic;
          B: in std_logic;
          C: in std_logic;
          S: out std_logic;
          T: out std_logic);
end full_adder;

architecture funktion of full_adder is
  begin
    S <= A xor B xor C;
    T <= (A and B) or (A and C) or (B and C);
end funktion;  