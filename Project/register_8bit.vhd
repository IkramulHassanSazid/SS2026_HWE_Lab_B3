-- 8-bit Data register

-- Designed by: HWE_LAB_B3

-- purpose: eventually build 8-it accumulator cpu

library ieee;

use ieee.std_logic_1164.all;



entity register_8bit is 

port (

CLK, RESET, LOAD : in std_logic;

D : in std_logic_vector(7 downto 0);

Q : out std_logic_vector(7 downto 0)

);
end entity;



architecture reg_arch of register_8bit is

begin

reg_proc: process(CLK, RESET, LOAD) is

  begin

	if (RESET='0') then Q <= "00000000";

		elsif ( rising_edge(CLK)) then

  		if (LOAD='1') then Q <= D;

  		end if;

	end if;

  end process reg_proc;



end reg_arch;
