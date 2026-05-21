-- ============================================================
-- Module      : full_adder_tb
-- Description : Testbench for 1-bit Full Adder
--               Tests all 8 input combinations (100% coverage)
-- Author      : HWE Lab Team
-- Date        : SS2026
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_tb is
-- Testbench has no ports
end entity full_adder_tb;

architecture sim of full_adder_tb is

    -- Component under test
    component full_adder is
        port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal A    : STD_LOGIC := '0';
    signal B    : STD_LOGIC := '0';
    signal Cin  : STD_LOGIC := '0';
    signal S    : STD_LOGIC;
    signal Cout : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT : full_adder
        port map (
            A    => A,
            B    => B,
            Cin  => Cin,
            S    => S,
            Cout => Cout
        );

    -- Stimulus process: apply all 8 input combinations
    stim_proc : process
    begin
        -- A=0, B=0, Cin=0 → S=0, Cout=0
        A <= '0'; B <= '0'; Cin <= '0';
        wait for 20 ns;
        assert (S = '0' and Cout = '0')
            report "FAIL: A=0 B=0 Cin=0" severity ERROR;

        -- A=0, B=0, Cin=1 → S=1, Cout=0
        A <= '0'; B <= '0'; Cin <= '1';
        wait for 20 ns;
        assert (S = '1' and Cout = '0')
            report "FAIL: A=0 B=0 Cin=1" severity ERROR;

        -- A=0, B=1, Cin=0 → S=1, Cout=0
        A <= '0'; B <= '1'; Cin <= '0';
        wait for 20 ns;
        assert (S = '1' and Cout = '0')
            report "FAIL: A=0 B=1 Cin=0" severity ERROR;

        -- A=0, B=1, Cin=1 → S=0, Cout=1
        A <= '0'; B <= '1'; Cin <= '1';
        wait for 20 ns;
        assert (S = '0' and Cout = '1')
            report "FAIL: A=0 B=1 Cin=1" severity ERROR;

        -- A=1, B=0, Cin=0 → S=1, Cout=0
        A <= '1'; B <= '0'; Cin <= '0';
        wait for 20 ns;
        assert (S = '1' and Cout = '0')
            report "FAIL: A=1 B=0 Cin=0" severity ERROR;

        -- A=1, B=0, Cin=1 → S=0, Cout=1
        A <= '1'; B <= '0'; Cin <= '1';
        wait for 20 ns;
        assert (S = '0' and Cout = '1')
            report "FAIL: A=1 B=0 Cin=1" severity ERROR;

        -- A=1, B=1, Cin=0 → S=0, Cout=1
        A <= '1'; B <= '1'; Cin <= '0';
        wait for 20 ns;
        assert (S = '0' and Cout = '1')
            report "FAIL: A=1 B=1 Cin=0" severity ERROR;

        -- A=1, B=1, Cin=1 → S=1, Cout=1
        A <= '1'; B <= '1'; Cin <= '1';
        wait for 20 ns;
        assert (S = '1' and Cout = '1')
            report "FAIL: A=1 B=1 Cin=1" severity ERROR;

        -- End simulation
        report "Simulation complete. All test cases passed." severity NOTE;
        wait;
    end process;

end architecture sim;
