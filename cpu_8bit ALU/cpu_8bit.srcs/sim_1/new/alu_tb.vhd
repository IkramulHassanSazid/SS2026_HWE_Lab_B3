-- ============================================================
-- File    : alu_tb.vhd
-- Author  : Ejaz (Team - HSHL 6th Semester BEng)
-- Purpose : Testbench for ALU
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_tb is
end entity alu_tb;

architecture sim of alu_tb is

    signal A      : std_logic_vector(7 downto 0) := (others => '0');
    signal B      : std_logic_vector(7 downto 0) := (others => '0');
    signal OP     : std_logic_vector(2 downto 0) := "000"; -- Updated to 3 bits
    signal Result : std_logic_vector(7 downto 0);
    signal Z_Flag : std_logic;
    signal C_Flag : std_logic;

begin

    -- Updated entity name and port mapping
    UUT: entity work.alu_8bit
        port map(
            A      => A,
            B      => B,
            OP     => OP,
            RESULT => Result,
            Z_Flag => Z_Flag,
            C_Flag => C_Flag
        );

    process
    begin
        -- TEST 1: ADD 5 + 3 = 8
        A <= "00000101";
        B <= "00000011"; 
        OP <= "001"; -- Updated ADD opcode
        wait for 20 ns;
        assert Result = "00001000" report "FAIL TEST 1: ADD 5+3 should be 8" severity error;
        report "TEST 1 ADD 5+3=8 >>> PASSED" severity note;

        -- TEST 2: SUB 5 - 3 = 2
        A <= "00000101";
        B <= "00000011"; 
        OP <= "010"; -- Updated SUB opcode
        wait for 20 ns;
        assert Result = "00000010" report "FAIL TEST 2: SUB 5-3 should be 2" severity error;
        report "TEST 2 SUB 5-3=2 >>> PASSED" severity note;

        -- TEST 3: SUB 3 - 3 = 0 (Zero flag = 1)
        A <= "00000011";
        B <= "00000011"; 
        OP <= "010"; -- Updated SUB opcode
        wait for 20 ns;
        assert Result = "00000000" report "FAIL TEST 3: SUB 3-3 should be 0" severity error;
        assert Z_Flag = '1' report "FAIL TEST 3: Zero flag should be 1" severity error;
        report "TEST 3 SUB 3-3=0 Z=1 >>> PASSED" severity note;

        -- TEST 4: AND 5 AND 3 = 1
        A <= "00000101";
        B <= "00000011"; 
        OP <= "011"; -- Updated AND opcode
        wait for 20 ns;
        assert Result = "00000001" report "FAIL TEST 4: AND should be 1" severity error;
        report "TEST 4 AND 5 AND 3=1 >>> PASSED" severity note;

        -- TEST 5: OR 5 OR 3 = 7
        A <= "00000101";
        B <= "00000011"; 
        OP <= "100"; -- Updated OR opcode
        wait for 20 ns;
        assert Result = "00000111" report "FAIL TEST 5: OR should be 7" severity error;
        report "TEST 5 OR 5 OR 3=7 >>> PASSED" severity note;

        -- TEST 6: Overflow 255 + 1 (Carry = 1)
        A <= "11111111";
        B <= "00000001"; 
        OP <= "001"; -- Updated ADD opcode
        wait for 20 ns;
        assert Result = "00000000" report "FAIL TEST 6: Overflow result should be 0" severity error;
        assert C_Flag = '1' report "FAIL TEST 6: Carry flag should be 1" severity error;
        report "TEST 6 OVERFLOW 255+1 >>> PASSED" severity note;

        report "===================================" severity note;
        report "ALL 6 ALU TESTS PASSED!" severity note;
        report "===================================" severity note;
        wait;
    end process;

end architecture sim;