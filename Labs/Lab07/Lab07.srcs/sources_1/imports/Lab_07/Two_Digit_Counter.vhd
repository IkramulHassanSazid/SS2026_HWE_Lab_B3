
-- Deliverable 1: Two_Digit_Counter.vhd
-- Reminder: NO IEEE libraries. Implicit std.standard only.

entity Two_Digit_Counter is
    port (
        CLK        : in  bit; -- 100 MHz system clock
        START_STOP : in  bit; -- SW0
        CLEAR      : in  bit; -- BTNC
        SEG        : out bit_vector(6 downto 0);
        AN         : out bit_vector(7 downto 0)
    );
end entity Two_Digit_Counter;

architecture structural of Two_Digit_Counter is

    -- 1. Declare the clock divider component from Exercise 01
    component clk_divider is
        generic ( N : integer );
        port (
            CLK   : in  bit;
            CLK_N : out bit
        );
    end component;

    -- Internal clocks
    signal clk_1Hz   : bit;
    signal clk_1kHz  : bit;

    -- Counter signals
    signal count_units : integer range 0 to 9 := 0;
    signal count_tens  : integer range 0 to 9 := 0;

    -- Multiplexer signals
    signal digit_sel     : bit := '0';
    signal current_digit : integer range 0 to 9 := 0;

begin

    -- 2. Instantiate 1 Hz Clock Divider (for the counter)
    -- 100,000,000 / 100,000,000 = 1 Hz
    div_1Hz : clk_divider
        generic map ( N => 100000000 )
        port map ( CLK => CLK, CLK_N => clk_1Hz );

    -- 3. Instantiate 1 kHz Clock Divider (for display multiplexing)
    -- 100,000,000 / 100,000 = 1,000 Hz
    div_1kHz : clk_divider
        generic map ( N => 100000 )
        port map ( CLK => CLK, CLK_N => clk_1kHz );

    -- 4. Two-Digit Counter Logic (Triggered by 1 Hz clock)
    process(clk_1Hz, CLEAR)
    begin
        if CLEAR = '1' then
            count_units <= 0;
            count_tens  <= 0;
            
        elsif clk_1Hz'event and clk_1Hz = '1' then
            if START_STOP = '1' then
                if count_units = 9 then
                    count_units <= 0;
                    -- Cascade to the tens digit
                    if count_tens = 9 then
                        count_tens <= 0;
                    else
                        count_tens <= count_tens + 1;
                    end if;
                else
                    count_units <= count_units + 1;
                end if;
            end if;
        end if;
    end process;

    -- 5. Multiplexer Flip-Flop (Triggered by 1 kHz clock)
    -- Toggles endlessly between '0' and '1' to swap displays
    process(clk_1kHz)
    begin
        if clk_1kHz'event and clk_1kHz = '1' then
            digit_sel <= not digit_sel;
        end if;
    end process;

    -- 6. Multiplexer Routing (Combinational)
    -- Routes the correct digit to the decoder and turns on the correct Anode
    process(digit_sel, count_units, count_tens)
    begin
        if digit_sel = '0' then
            current_digit <= count_units;
            AN <= "11111110"; -- Turn ON AN0 (Units)
        else
            current_digit <= count_tens;
            AN <= "11111101"; -- Turn ON AN1 (Tens)
        end if;
    end process;

    -- 7. The 7-Segment Decoder
    -- Translates the currently selected digit to segments (Active-LOW)
    process(current_digit)
    begin
        case current_digit is
            when 0 => SEG <= "0000001"; 
            when 1 => SEG <= "1001111"; 
            when 2 => SEG <= "0010010"; 
            when 3 => SEG <= "0000110";
            when 4 => SEG <= "1001100";
            when 5 => SEG <= "0100100";
            when 6 => SEG <= "0100000";
            when 7 => SEG <= "0001111";
            when 8 => SEG <= "0000000"; 
            when 9 => SEG <= "0000100";
            when others => SEG <= "1111111"; 
        end case;
    end process;

end architecture structural;