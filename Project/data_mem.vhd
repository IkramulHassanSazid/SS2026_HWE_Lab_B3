-- DATA MEMORY - 16 x 8, with memory-mapped switch INPUT.
-- Addressed by the instruction's operand field (IR 3..0).
--
-- This is where "input to the CPU" happens, with NO new instruction and
-- NO change to the control unit: two addresses are wired to the switches
-- instead of to RAM cells.
--
--   read address 14  -> SW(7..0)    (first operand / countdown start)
--   read address 15  -> SW(15..8)   (second operand)
--   all other reads  -> normal RAM
--
-- Writes (STA) always go to RAM. Writing to 14/15 is harmless (the read
-- of those addresses is overridden by the switches anyway).
--
-- Constants (ONE, ZERO) sit in the init below and are never written, so
-- they survive across resets - that is what makes programs re-runnable.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
port (
    CLK    : in  std_logic;
    RESET  : in  std_logic; -- NEW: Added hardware reset wire
    WE     : in  std_logic;
    ADDR   : in  std_logic_vector(3 downto 0);
    DIN    : in  std_logic_vector(7 downto 0);
    SW_LOW : in  std_logic_vector(7 downto 0);
    SW_HIGH: in  std_logic_vector(7 downto 0);
    DOUT   : out std_logic_vector(7 downto 0)
);
end entity;

architecture data_arch of data_mem is
    type ram_t is array (0 to 15) of std_logic_vector(7 downto 0);
    signal RAM : ram_t := (
        2  => "00000001",   -- ONE  = 1   (constant)
        3  => "00000000",   -- ZERO = 0   (constant)
        others => "00000000"
    );
begin
    -- synchronous write with asynchronous memory clear
    wr_proc: process(CLK, RESET) is
    begin
        if (RESET = '0') then
            -- NEW: Instantly zero out the Sum and Counter on reset!
            RAM(0) <= "00000000"; 
            RAM(1) <= "00000000";
        elsif rising_edge(CLK) then
            if (WE = '1') then
                RAM(to_integer(unsigned(ADDR))) <= DIN;
            end if;
        end if;
    end process wr_proc;

    -- asynchronous read with memory-mapped input ports
    rd_proc: process(ADDR, RAM, SW_LOW, SW_HIGH) is
    begin
        case ADDR is
            when "1110"  => DOUT <= SW_LOW;   -- address 14
            when "1111"  => DOUT <= SW_HIGH;  -- address 15
            when others  => DOUT <= RAM(to_integer(unsigned(ADDR)));
        end case;
    end process rd_proc;
end data_arch;