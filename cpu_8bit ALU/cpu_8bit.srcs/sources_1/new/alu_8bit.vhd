-- ============================================================
-- File    : alu_8bit.vhd
-- Author  : Ejaz (Team - HSHL 6th Semester BEng)
-- Version: 2.0
-- Purpose : 8-bit ALU for Accumulator CPU

--           Supports: ADD, SUB, AND, OR
-- ============================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_8bit is
 port (
        -- INPUTS
        A      : in  std_logic_vector(7 downto 0);  -- Operand A (from ACC)
        B      : in  std_logic_vector(7 downto 0);  -- Operand B (from Memory)
        OP : in  std_logic_vector(2 downto 0);  -- Operation selector

        -- OUTPUTS
        RESULT : out std_logic_vector(7 downto 0);  -- 8-bit result
        Z_Flag : out std_logic;                     -- Zero flag (1 if result = 0)
        C_Flag : out std_logic                      -- Carry flag (1 if overflow)
    );
end entity;

architecture alu_arch of alu_8bit is
   -- 9-bit signal to detect carry/overflow on bit 8
    signal result_int : unsigned(8 downto 0);

begin

    -- --------------------------------------------------------
    -- ALU Operation Selection
    -- ALU_Op = "00" → ADD
    -- ALU_Op = "01" → SUB
    -- ALU_Op = "10" → AND
    -- ALU_Op = "11" → OR
    -- --------------------------------------------------------
    process(A, B, OP)
    begin
        case OP is
            when "000"  => 
                result_int <= '0' & unsigned(B);                                          -- PASS  (used by LDA)
            when "001" =>  -- ADD
                result_int <= ('0' & unsigned(A)) + ('0' & unsigned(B));

            when "010" =>  -- SUB
                result_int <= ('0' & unsigned(A)) - ('0' & unsigned(B));

            when "011" =>  -- AND
                result_int <= '0' & (unsigned(A) and unsigned(B));

            when "100" =>  -- OR
                result_int <= '0' & (unsigned(A) or unsigned(B));

            when others =>
                result_int <= '0' & unsigned(A);

        end case;
    end process;

    -- --------------------------------------------------------
    -- Output assignments
    -- --------------------------------------------------------

    -- Lower 8 bits = the actual result
    RESULT <= std_logic_vector(result_int(7 downto 0));

    -- Carry flag = bit 8 (only meaningful for ADD/SUB)
    C_Flag <= result_int(8);

    -- Zero flag = 1 when all result bits are 0
    Z_Flag <= '1' when result_int(7 downto 0) = "00000000" else '0';

end alu_arch;
