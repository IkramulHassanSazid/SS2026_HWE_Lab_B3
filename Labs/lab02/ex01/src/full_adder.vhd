-- ============================================================
-- Module      : full_adder
-- Description : 1-bit Full Adder (Structural Modelling)
--               Uses two Half Adder instances + OR gate
-- Author      : HWE Lab Team
-- Date        : SS2026
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    port (
        A    : in  STD_LOGIC;
        B    : in  STD_LOGIC;
        Cin  : in  STD_LOGIC;
        S    : out STD_LOGIC;   -- Sum
        Cout : out STD_LOGIC    -- Carry out
    );
end entity full_adder;

architecture structural of full_adder is

    -- Component declaration of half_adder
    component half_adder is
        port (
            A : in  STD_LOGIC;
            B : in  STD_LOGIC;
            S : out STD_LOGIC;
            C : out STD_LOGIC
        );
    end component;

    -- Internal signals
    signal S1  : STD_LOGIC;  -- Sum output of first Half Adder
    signal C1  : STD_LOGIC;  -- Carry output of first Half Adder
    signal C2  : STD_LOGIC;  -- Carry output of second Half Adder

begin

    -- First Half Adder: inputs A and B
    HA1 : half_adder
        port map (
            A => A,
            B => B,
            S => S1,
            C => C1
        );

    -- Second Half Adder: inputs S1 and Cin
    HA2 : half_adder
        port map (
            A => S1,
            B => Cin,
            S => S,
            C => C2
        );

    -- Final Carry out: OR of both half adder carries
    Cout <= C1 OR C2;

end architecture structural;
