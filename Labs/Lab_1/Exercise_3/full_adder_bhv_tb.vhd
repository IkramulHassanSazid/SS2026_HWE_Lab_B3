
entity full_adder_tb is
-- Testbenches have no ports
end full_adder_tb;

architecture Simulation of full_adder_tb is
    -- Component Declaration
    component full_adder
        Port ( A    : in  bit;
               B    : in  bit;
               Cin  : in  bit;
               Sum  : out bit;
               Cout : out bit);
    end component;

    -- Signal declarations
    signal A_tb   : bit;
    signal B_tb   : bit;
    signal Cin_tb : bit;
    signal Sum_tb : bit;
    signal Cout_tb: bit;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: full_adder port map (
          A    => A_tb,
          B    => B_tb,
          Cin  => Cin_tb,
          Sum  => Sum_tb,
          Cout => Cout_tb
        );

    -- Concurrent assignments covering all 8 binary combinations (000 to 111)
    A_tb   <= '0', '0' after 10 ns, '0' after 20 ns, '0' after 30 ns, '1' after 40 ns, '1' after 50 ns, '1' after 60 ns, '1' after 70 ns;
    B_tb   <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns, '0' after 40 ns, '0' after 50 ns, '1' after 60 ns, '1' after 70 ns;
    Cin_tb <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns, '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns;

end Simulation;