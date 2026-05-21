-- ============================================================
-- Module      : half_adder
-- Description : 1-bit Half Adder (Dataflow Modelling)
-- Author      : HWE Lab Team
-- Date        : SS2026
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    port (
        A : in  STD_LOGIC;
        B : in  STD_LOGIC;
        S : out STD_LOGIC;   -- Sum
        C : out STD_LOGIC    -- Carry
    );
end entity half_adder;

architecture dataflow of half_adder is
begin
    S <= A XOR B;
    C <= A AND B;
end architecture dataflow;
