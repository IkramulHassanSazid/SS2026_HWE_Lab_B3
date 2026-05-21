
-- Entity declaration
entity half_subtractor is
    Port ( A      : in  bit;
           B      : in  bit;
           Diff   : out bit;
           Borrow : out bit);
end half_subtractor;

-- Architecture definition
architecture Behavioral of half_subtractor is
begin
    Diff   <= A xor B;
    Borrow <= (not A) and B;
end Behavioral;