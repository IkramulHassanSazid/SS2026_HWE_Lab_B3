-- 4-bit Program Counter (PC)
-- purpose: points at the next instruction in memory (16 locations -> 4 bits)
-- conventions match register_8bit: active-low async RESET

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_4bit is
port (
    CLK, RESET : in  std_logic;
    INC        : in  std_logic;                     -- count up by 1
    LOAD       : in  std_logic;                     -- jump: load a new address
    D          : in  std_logic_vector(3 downto 0);  -- jump target
    Q          : out std_logic_vector(3 downto 0)   -- current address
);
end entity;

architecture pc_arch of pc_4bit is
    signal count : unsigned(3 downto 0) := (others => '0');
begin
    pc_proc: process(CLK, RESET) is
    begin
        if (RESET = '0') then
            count <= (others => '0');
        elsif rising_edge(CLK) then
            if (LOAD = '1') then          -- LOAD wins over INC (jump)
                count <= unsigned(D);
            elsif (INC = '1') then
                count <= count + 1;
            end if;
        end if;
    end process pc_proc;

    Q <= std_logic_vector(count);
end pc_arch;
