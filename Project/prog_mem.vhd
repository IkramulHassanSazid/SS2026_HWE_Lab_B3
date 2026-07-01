library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prog_mem is
port (
    ADDR : in  std_logic_vector(3 downto 0);
    DOUT : out std_logic_vector(7 downto 0)
);
end entity;

architecture rom_arch of prog_mem is
    type rom_t is array (0 to 15) of std_logic_vector(7 downto 0);
    constant ROM : rom_t := (
        -- [MULTIPLICATION SETUP]
        0  => "00011111",   -- LDA 15   ; ACC <- Operand B (from SW 15..8)
        1  => "01000001",   -- STA 1    ; counter <- B
        
        -- [MULTIPLICATION LOOP]
        2  => "00010001",   -- LDA 1    ; ACC <- counter
        3  => "10001010",   -- JZ  10   ; if counter == 0, jump to Countdown Loop
        4  => "00110010",   -- SUB 2    ; ACC <- counter - 1 (Address 2 holds the constant '1')
        5  => "01000001",   -- STA 1    ; counter <- ACC
        6  => "00010000",   -- LDA 0    ; ACC <- sum (Address 0)
        7  => "00101110",   -- ADD 14   ; ACC <- sum + Operand A (from SW 7..0)
        8  => "01000000",   -- STA 0    ; sum <- ACC
        9  => "01110010",   -- JMP 2    ; loop back to mult
        
        -- [COUNTDOWN LOOP & HALT]
        10 => "00010000",   -- LDA 0    ; ACC <- sum
        11 => "11100000",   -- OUT      ; display the current sum
        12 => "10001111",   -- JZ  15   ; if sum == 0, jump to line 15 (Halt)
        13 => "00110010",   -- SUB 2    ; ACC <- sum - 1
        14 => "01000000",   -- STA 0    ; sum <- ACC
        15 => "01111010"    -- JMP 10   ; Infinite loop back to 10 (Acts as a Software Halt)
    );
begin
    DOUT <= ROM(to_integer(unsigned(ADDR)));
end rom_arch;