library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_half_adder is
-- Testbenches have no ports
end entity;

architecture behavior of tb_half_adder is

    -- Component Declaration for the Unit Under Test (UUT)
    component half_adder is
        port (a, b : in bit;
              s, c : out bit);
    end component;

    -- Signals to connect to UUT
    signal a_tb : bit := '0';
    signal b_tb : bit := '0';
    signal s_tb : bit;
    signal c_tb : bit;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: half_adder port map (
          a => a_tb,
          b => b_tb,
          s => s_tb,
          c => c_tb
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test Case 1: 0 + 0
        a_tb <= '0'; b_tb <= '0';
        wait for 10 ns;
        
        -- Test Case 2: 0 + 1
        a_tb <= '0'; b_tb <= '1';
        wait for 10 ns;
        
        -- Test Case 3: 1 + 0
        a_tb <= '1'; b_tb <= '0';
        wait for 10 ns;
        
        -- Test Case 4: 1 + 1
        a_tb <= '1'; b_tb <= '1';
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end architecture;