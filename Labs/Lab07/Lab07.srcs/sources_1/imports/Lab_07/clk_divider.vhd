
entity clk_divider is
    generic (
        N : integer := 4  -- Default division factor
    );
    port (
        CLK   : in  bit;  -- Using 'bit' instead of 'std_logic'
        CLK_N : out bit
    );
end entity clk_divider;

architecture behavioral of clk_divider is
    -- Internal signals
    signal count    : integer := 0;
    signal temp_clk : bit := '0';
begin
    
    process(CLK)
    begin
        -- Standard VHDL way to detect a rising edge without IEEE libraries
        if CLK'event and CLK = '1' then 
            
            -- Toggle the clock when we reach half the division factor
            if count = (N / 2) - 1 then
                temp_clk <= not temp_clk;
                count <= 0; -- Reset counter
            else
                count <= count + 1;
            end if;
            
        end if;
    end process;

    -- Assign the internal temporary clock to the output port
    CLK_N <= temp_clk;

end architecture behavioral;