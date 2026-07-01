-- 8-bit ALU (combinational - no clock)
-- A is always the accumulator, B is the operand fetched from memory.
-- OP selects the operation. RESULT goes back into the accumulator.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_8bit is
port (
    A      : in  std_logic_vector(7 downto 0);  -- from ACC
    B      : in  std_logic_vector(7 downto 0);  -- from memory
    OP     : in  std_logic_vector(2 downto 0);  -- operation select
    RESULT : out std_logic_vector(7 downto 0)
);
end entity;

architecture alu_arch of alu_8bit is
begin
    alu_proc: process(A, B, OP) is
    begin
        case OP is
            when "000"  => RESULT <= B;                                          -- PASS  (used by LDA)
            when "001"  => RESULT <= std_logic_vector(unsigned(A) + unsigned(B)); -- ADD
            when "010"  => RESULT <= std_logic_vector(unsigned(A) - unsigned(B)); -- SUB
            when "011"  => RESULT <= A and B;                                    -- AND
            when "100"  => RESULT <= A or  B;                                    -- OR
            when others => RESULT <= A;                                          -- default: keep A
        end case;
    end process alu_proc;
end alu_arch;
