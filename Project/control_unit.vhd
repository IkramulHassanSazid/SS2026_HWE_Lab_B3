-- Control Unit (the DECODE block in the diagram + the CPU's "conductor")
-- A small finite state machine with 3 states:
--
--   FETCH   : grab instruction at M[PC] into IR, and bump PC by 1
--   EXECUTE : look at the opcode in IR and pulse the right control wires
--   HALTED  : do nothing forever (until reset)
--
-- Every instruction takes exactly 2 clock cycles (FETCH + EXECUTE).

library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
port (
    CLK, RESET : in  std_logic;
    OPCODE     : in  std_logic_vector(3 downto 0); -- IR bits 7..4
    ZERO       : in  std_logic;                    -- '1' when ACC = 0 (for JZ)

    PC_INC     : out std_logic;   -- program counter +1
    PC_LOAD    : out std_logic;   -- program counter <= jump address
    IR_LOAD    : out std_logic;   -- instruction register <= memory
    ACC_LOAD   : out std_logic;   -- accumulator <= ALU result
    MEM_WE     : out std_logic;   -- memory write (STA)
    OUT_LOAD   : out std_logic;   -- output register <= ACC
    ALU_OP     : out std_logic_vector(2 downto 0);
    ADDR_SEL   : out std_logic;   -- memory address: '0' = PC (fetch), '1' = IR operand
    HALTED     : out std_logic
);
end entity;

architecture ctrl_arch of control_unit is

    type state_t is (S_FETCH, S_EXECUTE, S_HALT);
    signal state : state_t := S_FETCH;

    -- opcode names so the code reads like the instruction set
    constant OP_NOP : std_logic_vector(3 downto 0) := "0000";
    constant OP_LDA : std_logic_vector(3 downto 0) := "0001";
    constant OP_ADD : std_logic_vector(3 downto 0) := "0010";
    constant OP_SUB : std_logic_vector(3 downto 0) := "0011";
    constant OP_STA : std_logic_vector(3 downto 0) := "0100";
    constant OP_AND : std_logic_vector(3 downto 0) := "0101";
    constant OP_OR  : std_logic_vector(3 downto 0) := "0110";
    constant OP_JMP : std_logic_vector(3 downto 0) := "0111";
    constant OP_JZ  : std_logic_vector(3 downto 0) := "1000";
    constant OP_OUT : std_logic_vector(3 downto 0) := "1110";
    constant OP_HLT : std_logic_vector(3 downto 0) := "1111";

begin

    -- state register: where are we in the fetch/execute cycle?
    state_proc: process(CLK, RESET) is
    begin
        if (RESET = '0') then
            state <= S_FETCH;
        elsif rising_edge(CLK) then
            case state is
                when S_FETCH   => state <= S_EXECUTE;
                when S_EXECUTE =>
                    if (OPCODE = OP_HLT) then
                        state <= S_HALT;
                    else
                        state <= S_FETCH;
                    end if;
                when S_HALT    => state <= S_HALT;
            end case;
        end if;
    end process state_proc;

    -- output logic: which control wires are ON in this state, for this opcode?
    out_proc: process(state, OPCODE, ZERO) is
    begin
        -- default: everything OFF (safe values)
        PC_INC   <= '0';
        PC_LOAD  <= '0';
        IR_LOAD  <= '0';
        ACC_LOAD <= '0';
        MEM_WE   <= '0';
        OUT_LOAD <= '0';
        ALU_OP   <= "000";
        ADDR_SEL <= '0';
        HALTED   <= '0';

        case state is

            when S_FETCH =>
                ADDR_SEL <= '0';   -- memory address comes from PC
                IR_LOAD  <= '1';   -- IR <= M[PC]
                PC_INC   <= '1';   -- PC <= PC + 1 (same clock edge)

            when S_EXECUTE =>
                ADDR_SEL <= '1';   -- memory address comes from IR(3..0)
                case OPCODE is
                    when OP_LDA => ALU_OP <= "000"; ACC_LOAD <= '1'; -- ACC <= mem
                    when OP_ADD => ALU_OP <= "001"; ACC_LOAD <= '1';
                    when OP_SUB => ALU_OP <= "010"; ACC_LOAD <= '1';
                    when OP_AND => ALU_OP <= "011"; ACC_LOAD <= '1';
                    when OP_OR  => ALU_OP <= "100"; ACC_LOAD <= '1';
                    when OP_STA => MEM_WE <= '1';                    -- mem <= ACC
                    when OP_JMP => PC_LOAD <= '1';
                    when OP_JZ  =>
                        if (ZERO = '1') then PC_LOAD <= '1'; end if;
                    when OP_OUT => OUT_LOAD <= '1';
                    when others => null;                             -- NOP, HLT
                end case;

            when S_HALT =>
                HALTED <= '1';

        end case;
    end process out_proc;

end ctrl_arch;
