
-- Entity declaration
entity full_subtractor is
    Port ( A    : in  bit;
           B    : in  bit;
           Bin  : in  bit;
           Diff : out bit;
           Bout : out bit);
end full_subtractor;

-- Architecture definition
architecture Behavioral of full_subtractor is
begin
    -- Difference logic
    Diff <= A xor B xor Bin;
    -- Borrow Out logic
    Bout <= ((not A) and B) or ((not A) and Bin) or (B and Bin);
end Behavioral;