-- 7-SEGMENT DISPLAY CONTROLLER  (a self-contained peripheral)
--
-- This module knows NOTHING about the CPU. You hand it a 32-bit value
-- (eight 4-bit hex digits) and a blank mask, and it drives the Nexys A7's
-- 8-digit display by time-multiplexing - lighting one digit at a time so
-- fast (~760 Hz per digit) that the eye sees all eight at once.
--
-- digit 0 = VALUE(3 downto 0)  is the RIGHTMOST digit.
-- BLANK(i) = '1' turns digit i off (used to leave gaps between numbers).
--
-- Runs entirely off the raw 100 MHz clock, independent of the (slow) CPU
-- clock - that is why the display stays bright while the CPU crawls.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg7_controller is
port (
    CLK100MHZ : in  std_logic;
    VALUE     : in  std_logic_vector(31 downto 0);  -- 8 hex nibbles
    BLANK     : in  std_logic_vector(7 downto 0);   -- 1 = digit off
    AN        : out std_logic_vector(7 downto 0);   -- anode enables (active low)
    SEG       : out std_logic_vector(6 downto 0);   -- CA..CG (active low)
    DP        : out std_logic                       -- decimal point (active low)
);
end entity;

architecture seg_arch of seg7_controller is
    signal refresh : unsigned(19 downto 0) := (others => '0');
    signal sel     : integer range 0 to 7;
    signal nibble  : std_logic_vector(3 downto 0);
    signal blanked : std_logic;
begin
    -- free-running refresh counter
    process(CLK100MHZ) is
    begin
        if rising_edge(CLK100MHZ) then
            refresh <= refresh + 1;
        end if;
    end process;

    sel <= to_integer(refresh(19 downto 17));   -- which digit is active now

    -- pick this digit's nibble and whether it should be blanked
    nibble  <= VALUE(4*sel + 3 downto 4*sel);
    blanked <= BLANK(sel);

    -- one-hot active-low anode drive
    an_proc: process(sel, blanked) is
    begin
        AN <= (others => '1');          -- all off ...
        if (blanked = '0') then
            AN(sel) <= '0';             -- ... except the active digit
        end if;
    end process;

    -- hex -> 7-segment pattern (active low: '0' lights the segment)
    seg_proc: process(nibble) is
    begin
        case nibble is
            when "0000" => SEG <= "1000000"; -- 0
            when "0001" => SEG <= "1111001"; -- 1
            when "0010" => SEG <= "0100100"; -- 2
            when "0011" => SEG <= "0110000"; -- 3
            when "0100" => SEG <= "0011001"; -- 4
            when "0101" => SEG <= "0010010"; -- 5
            when "0110" => SEG <= "0000010"; -- 6
            when "0111" => SEG <= "1111000"; -- 7
            when "1000" => SEG <= "0000000"; -- 8
            when "1001" => SEG <= "0010000"; -- 9
            when "1010" => SEG <= "0001000"; -- A
            when "1011" => SEG <= "0000011"; -- b
            when "1100" => SEG <= "1000110"; -- C
            when "1101" => SEG <= "0100001"; -- d
            when "1110" => SEG <= "0000110"; -- E
            when others => SEG <= "0001110"; -- F
        end case;
    end process;

    DP <= '1';   -- decimal point off
end seg_arch;
