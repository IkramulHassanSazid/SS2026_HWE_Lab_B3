-- ============================================================
-- Module      : CR_adder
-- Description : 4-bit Ripple Carry Adder (Structural Modelling)
--               Uses four Full Adder instances chained together
-- Author      : HWE Lab Team
-- Date        : SS2026
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CR_adder is
    generic (
        N : integer := 4  -- bit width, can be changed for any size!
    );
    port (
        A    : in  STD_LOGIC_VECTOR(N-1 downto 0);  -- 4-bit input A
        B    : in  STD_LOGIC_VECTOR(N-1 downto 0);  -- 4-bit input B
        Cin  : in  STD_LOGIC;                        -- Carry in
        S    : out STD_LOGIC_VECTOR(N-1 downto 0);  -- 4-bit Sum
        Cout : out STD_LOGIC                         -- Carry out
    );
end entity CR_adder;

architecture structural of CR_adder is

    -- Component declaration of full_adder
    component full_adder is
        port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    -- Internal carry signals between full adders
    signal carry : STD_LOGIC_VECTOR(N downto 0);

begin

    -- Connect initial carry in
    carry(0) <= Cin;

    -- Generate N full adder instances
    GEN_FA : for i in 0 to N-1 generate
        FA_i : full_adder
            port map (
                A    => A(i),
                B    => B(i),
                Cin  => carry(i),
                S    => S(i),
                Cout => carry(i+1)
            );
    end generate;

    -- Final carry out
    Cout <= carry(N);

end architecture structural;
