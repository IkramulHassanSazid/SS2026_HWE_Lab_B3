library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    port (a,b : in bit; -- two input 
		s, c : out bit);
    end entity;

architecture structure of half_adder is
begin
    s <= a xor b;
    c <= a and b;
end structure;