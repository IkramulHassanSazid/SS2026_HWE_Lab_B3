-- Entity declaration
entity full_adder is
    Port ( A    : in  bit;
           B    : in  bit;
           Cin  : in  bit;
           Sum  : out bit;
           Cout : out bit);
end full_adder;

-- Architecture definition
architecture Behavioral of full_adder is
begin
    -- Behavioral logic for Sum and Carry Out
    Sum  <= A xor B xor Cin;
    Cout <= (A and B) or (B and Cin) or (A and Cin);
end Behavioral;