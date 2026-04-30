
entity half_subtractor_tb is
-- Testbenches have no ports
end half_subtractor_tb;

architecture Simulation of half_subtractor_tb is
    -- Component Declaration
    component half_subtractor
        Port ( A      : in  bit;
               B      : in  bit;
               Diff   : out bit;
               Borrow : out bit);
    end component;

    -- Signal declarations
    signal A_tb      : bit;
    signal B_tb      : bit;
    signal Diff_tb   : bit;
    signal Borrow_tb : bit;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: half_subtractor port map (
          A => A_tb,
          B => B_tb,
          Diff => Diff_tb,
          Borrow => Borrow_tb
        );

    -- Concurrent signal assignments for 100% coverage
    A_tb <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns;
    B_tb <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns;

end Simulation;