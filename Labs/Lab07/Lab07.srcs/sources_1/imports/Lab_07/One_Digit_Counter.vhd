
-- Deliverable 1: One_Digit_Counter.vhd
-- Reminder: No IEEE libraries, relying purely on std.standard

entity One_Digit_Counter is
    port (
        CLK        : in  bit; -- 100 MHz system clock
        START_STOP : in  bit; -- Mapped to a switch
        CLEAR      : in  bit; -- Mapped to a button
        SEG        : out bit_vector(6 downto 0); -- 7 segments (CA to CG)
        AN         : out bit_vector(7 downto 0)  -- 8 digit selectors
    );
end entity One_Digit_Counter;

architecture structural of One_Digit_Counter is

    -- 1. Declare the clock divider from Exercise 01
    component clk_divider is
        generic ( N : integer );
        port (
            CLK   : in  bit;
            CLK_N : out bit
        );
    end component;

    -- Internal signals
    signal slow_clk : bit;
    signal count    : integer range 0 to 9 := 0;

begin

    -- 2. Instantiate the Clock Divider
    -- Dividing 100,000,000 Hz by 100,000,000 gives us a 1 Hz clock (1 tick/sec)
    div_inst : clk_divider
        generic map (
            N => 100000000
        )
        port map (
            CLK   => CLK,
            CLK_N => slow_clk
        );

    -- 3. The Counter Logic
    process(slow_clk, CLEAR)
    begin
        -- Asynchronous CLEAR: Resets to 0 immediately, even if stopped
        if CLEAR = '1' then
            count <= 0;
            
        -- Otherwise, count on the rising edge of our 1 Hz clock
        elsif slow_clk'event and slow_clk = '1' then
            -- Only count if the START_STOP enable switch is HIGH
            if START_STOP = '1' then
                if count = 9 then
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    -- 4. The 7-Segment Decoder (Active-LOW: '0' = ON, '1' = OFF)
    -- Vector order: CA, CB, CC, CD, CE, CF, CG
    process(count)
    begin
        case count is
            when 0 => SEG <= "0000001"; -- Only G is OFF
            when 1 => SEG <= "1001111"; -- B, C are ON
            when 2 => SEG <= "0010010"; 
            when 3 => SEG <= "0000110";
            when 4 => SEG <= "1001100";
            when 5 => SEG <= "0100100";
            when 6 => SEG <= "0100000";
            when 7 => SEG <= "0001111";
            when 8 => SEG <= "0000000"; -- All ON
            when 9 => SEG <= "0000100";
            when others => SEG <= "1111111"; -- All OFF (safety fallback)
        end case;
    end process;

    -- 5. Anode Control
    -- Enable only the right-most digit (AN0). Active-LOW means '0' turns it on.
    AN <= "11111110";

end architecture structural;