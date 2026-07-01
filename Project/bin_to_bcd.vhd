library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_to_bcd is
    port (
        BIN_IN   : in  std_logic_vector(7 downto 0); -- 0 to 255
        HUNDREDS : out std_logic_vector(3 downto 0);
        TENS     : out std_logic_vector(3 downto 0);
        ONES     : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behavior of bin_to_bcd is
begin
    process(BIN_IN)
        variable int_val : integer range 0 to 255;
        variable h, t, o : integer range 0 to 9;
    begin
        -- Convert binary input to integer
        int_val := to_integer(unsigned(BIN_IN));

        -- Extract base-10 digits using division and modulo
        h := int_val / 100;
        t := (int_val / 10) mod 10;
        o := int_val mod 10;

        -- Convert back to 4-bit binary chunks for the 7-segment controller
        HUNDREDS <= std_logic_vector(to_unsigned(h, 4));
        TENS     <= std_logic_vector(to_unsigned(t, 4));
        ONES     <= std_logic_vector(to_unsigned(o, 4));
    end process;
end behavior;