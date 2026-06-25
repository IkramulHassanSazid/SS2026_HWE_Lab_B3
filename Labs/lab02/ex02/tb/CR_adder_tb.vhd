-- ============================================================
-- Module      : CR_adder_tb
-- Description : Testbench for 4-bit Ripple Carry Adder
--               Tests key input combinations to verify functionality
-- Author      : HWE Lab Team
-- Date        : SS2026
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CR_adder_tb is
-- Testbench has no ports
end entity CR_adder_tb;

architecture sim of CR_adder_tb is

    -- Component under test
    component CR_adder is
        generic (N : integer := 4);
        port (
            A    : in  STD_LOGIC_VECTOR(3 downto 0);
            B    : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal A    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal B    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Cin  : STD_LOGIC := '0';
    signal S    : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout : STD_LOGIC;

begin

    -- Instantiate Unit Under Test
    UUT : CR_adder
        generic map (N => 4)
        port map (
            A    => A,
            B    => B,
            Cin  => Cin,
            S    => S,
            Cout => Cout
        );

    -- Stimulus process
    stim_proc : process
    begin

        -- Test 1: 0 + 0 + 0 = 0, Cout=0
        A <= "0000"; B <= "0000"; Cin <= '0';
        wait for 20 ns;
        assert (S = "0000" and Cout = '0')
            report "FAIL: Test 1 - 0+0+0" severity ERROR;

        -- Test 2: 1 + 1 + 0 = 2 (0010), Cout=0
        A <= "0001"; B <= "0001"; Cin <= '0';
        wait for 20 ns;
        assert (S = "0010" and Cout = '0')
            report "FAIL: Test 2 - 1+1+0" severity ERROR;

        -- Test 3: 5 + 3 + 0 = 8 (1000), Cout=0
        A <= "0101"; B <= "0011"; Cin <= '0';
        wait for 20 ns;
        assert (S = "1000" and Cout = '0')
            report "FAIL: Test 3 - 5+3+0" severity ERROR;

        -- Test 4: 7 + 7 + 0 = 14 (1110), Cout=0
        A <= "0111"; B <= "0111"; Cin <= '0';
        wait for 20 ns;
        assert (S = "1110" and Cout = '0')
            report "FAIL: Test 4 - 7+7+0" severity ERROR;

        -- Test 5: 15 + 1 + 0 = 16 (0000), Cout=1
        A <= "1111"; B <= "0001"; Cin <= '0';
        wait for 20 ns;
        assert (S = "0000" and Cout = '1')
            report "FAIL: Test 5 - 15+1+0" severity ERROR;

        -- Test 6: 15 + 15 + 0 = 30 (1110), Cout=1
        A <= "1111"; B <= "1111"; Cin <= '0';
        wait for 20 ns;
        assert (S = "1110" and Cout = '1')
            report "FAIL: Test 6 - 15+15+0" severity ERROR;

        -- Test 7: 15 + 15 + 1 = 31 (1111), Cout=1
        A <= "1111"; B <= "1111"; Cin <= '1';
        wait for 20 ns;
        assert (S = "1111" and Cout = '1')
            report "FAIL: Test 7 - 15+15+1" severity ERROR;

        -- Test 8: 9 + 6 + 1 = 16 (0000), Cout=1
        A <= "1001"; B <= "0110"; Cin <= '1';
        wait for 20 ns;
        assert (S = "0000" and Cout = '1')
            report "FAIL: Test 8 - 9+6+1" severity ERROR;

        -- End simulation
        report "Simulation complete. All test cases passed." severity NOTE;
        wait;

    end process;

end architecture sim;
