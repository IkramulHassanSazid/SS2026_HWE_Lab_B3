
entity full_subtractor_tb is
-- Testbenches have no ports
end full_subtractor_tb;

architecture Simulation of full_subtractor_tb is
    -- Component Declaration
    component full_subtractor
        Port ( A    : in  bit;
               B    : in  bit;
               Bin  : in  bit;
               Diff : out bit;
               Bout : out bit);
    end component;

    -- Signal declarations
    signal A_tb   : bit;
    signal B_tb   : bit;
    signal Bin_tb : bit;
    signal Diff_tb: bit;
    signal Bout_tb: bit;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: full_subtractor port map (
          A    => A_tb,
          B    => B_tb,
          Bin  => Bin_tb,
          Diff => Diff_tb,
          Bout => Bout_tb
        );

    -- Concurrent assignments covering all 8 binary combinations (000 to 111)
    A_tb   <= '0', '0' after 10 ns, '0' after 20 ns, '0' after 30 ns, '1' after 40 ns, '1' after 50 ns, '1' after 60 ns, '1' after 70 ns;
    B_tb   <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns, '0' after 40 ns, '0' after 50 ns, '1' after 60 ns, '1' after 70 ns;
    Bin_tb <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns, '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns;

end Simulation;