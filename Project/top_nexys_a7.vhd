-- BOARD TOP for the Nexys A7-100T
--
-- Ties together three things:
--   1. the CPU core  (reads operands from the switches via data_mem)
--   2. the 7-segment controller (shows operands + result)
--   3. a clock divider whose speed depends on which demo is built
--
-- One generic, DEMO_MULT, selects everything that differs between the two
-- showcase programs. Build the project twice, flipping this generic, and
-- swapping prog_mem.vhd / data_mem.vhd for the matching program:
--
--   DEMO_MULT = true   -> use prog_mem.vhd            + data_mem.vhd
--                         
--   DEMO_MULT = false  -> use prog_mem_countdown.vhd  + data_mem_countdown.vhd
--                         ~1 Hz CPU clock; display = count
--
-- Switch usage:
--   MULTIPLY : SW(7..0)  = operand A,  SW(15..8) = operand B
--   COUNTDOWN: SW(7..0)  = start value
-- Press the red CPU RESET button after setting the switches to (re)run.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_nexys_a7 is
generic (
    DEMO_MULT : boolean := true
);
port (
    CLK100MHZ  : in  std_logic;
    CPU_RESETN : in  std_logic;
    SW         : in  std_logic_vector(15 downto 0);
    LED        : out std_logic_vector(15 downto 0);
    AN         : out std_logic_vector(7 downto 0);
    SEG        : out std_logic_vector(6 downto 0);   -- CA..CG
    DP         : out std_logic
);
end entity;

architecture top_arch of top_nexys_a7 is
    signal div      : unsigned(24 downto 0) := (others => '0');
    signal cpu_clk  : std_logic;
    signal out_port : std_logic_vector(7 downto 0);
    signal acc_dbg  : std_logic_vector(7 downto 0);
    signal halted   : std_logic;

    signal disp_val : std_logic_vector(31 downto 0);
    signal disp_bl  : std_logic_vector(7 downto 0);
    signal bcd_hund : std_logic_vector(3 downto 0); -- to convert to bcd
    signal bcd_tens : std_logic_vector(3 downto 0);
    signal bcd_ones : std_logic_vector(3 downto 0);
    -- BCD signals for the Output Result


    -- NEW: BCD signals for Operand A (SW 7..0)
    signal bcd_a_hund : std_logic_vector(3 downto 0); -- We will calculate this but ignore it
    signal bcd_a_tens : std_logic_vector(3 downto 0);
    signal bcd_a_ones : std_logic_vector(3 downto 0);

    -- NEW: BCD signals for Operand B (SW 15..8)
    signal bcd_b_hund : std_logic_vector(3 downto 0); -- We will calculate this but ignore it
    signal bcd_b_tens : std_logic_vector(3 downto 0);
    signal bcd_b_ones : std_logic_vector(3 downto 0);

    -- fast clock bit for multiply (~6 kHz), slow for countdown (~12 Hz)
    constant CLK_BIT : integer := 13;     -- changed to 22 for countdown (see below)
begin
    process(CLK100MHZ) is
    begin
        if rising_edge(CLK100MHZ) then
            div <= div + 1;
        end if;
    end process;

    -- pick the CPU clock speed for the selected demo
    cpu_clk <= div(20);

    U_BCD: entity work.bin_to_bcd
        port map (
            BIN_IN   => out_port,
            HUNDREDS => bcd_hund,
            TENS     => bcd_tens,
            ONES     => bcd_ones
        );
        
    -- NEW: Converter for Switch A (Right Switches)
    U_BCD_A: entity work.bin_to_bcd
        port map (
            BIN_IN   => SW(7 downto 0),
            HUNDREDS => bcd_a_hund,
            TENS     => bcd_a_tens,
            ONES     => bcd_a_ones
        );

    -- NEW: Converter for Switch B (Left Switches)
    U_BCD_B: entity work.bin_to_bcd
        port map (
            BIN_IN   => SW(15 downto 8),
            HUNDREDS => bcd_b_hund,
            TENS     => bcd_b_tens,
            ONES     => bcd_b_ones
        );
    
    U_CPU: entity work.cpu_core
        port map (CLK => cpu_clk, RESET => CPU_RESETN,
                  SW_LOW => SW(7 downto 0), SW_HIGH => SW(15 downto 8),
                  OUT_PORT => out_port, ACC_DEBUG => acc_dbg, HALTED => halted);

    -- compose what the 8 digits show, per demo
    gen_mult: if DEMO_MULT generate
        -- digits:  [7 6]=operand B   [5 4]=operand A   [3]=blank  [2]=hund [1]=tens [0]=ones
        disp_val <= bcd_b_tens & bcd_b_ones & bcd_a_tens & bcd_a_ones & x"0" & bcd_hund & bcd_tens & bcd_ones;
        disp_bl  <= "00001000"; -- Blank digit 3
    end generate;

    gen_count: if not DEMO_MULT generate
        -- digits:  [2]=hund [1]=tens [0]=ones, everything else blank
        disp_val <= x"00000" & bcd_hund & bcd_tens & bcd_ones;
        disp_bl  <= "11111000"; -- Blank digits 7 through 3
    end generate;

    U_SEG: entity work.seg7_controller
        port map (CLK100MHZ => CLK100MHZ, VALUE => disp_val, BLANK => disp_bl,
                  AN => AN, SEG => SEG, DP => DP);

    LED(7 downto 0)  <= out_port;
    LED(15 downto 8) <= acc_dbg;
end top_arch;
