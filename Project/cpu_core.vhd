-- CPU CORE (Harvard version)
-- Same datapath as before, but with TWO memories instead of one:
--   prog_mem  - addressed by the PC, feeds the IR (instructions)
--   data_mem  - addressed by the IR operand, feeds the ALU / takes STA (data)
--
-- Because the two memories are separate buses, the old address mux is gone.
-- Fetch reads prog_mem; execute reads/writes data_mem. Cleaner, and it gives
-- the program a full 16 instruction slots AND a full 16 data cells.
--
-- The accumulator, IR, output register, ALU, PC and control unit are the
-- SAME verified files as before - none of them changed.

library ieee;
use ieee.std_logic_1164.all;

entity cpu_core is
port (
    CLK, RESET : in  std_logic;
    SW_LOW     : in  std_logic_vector(7 downto 0);  -- SW(7..0)
    SW_HIGH    : in  std_logic_vector(7 downto 0);  -- SW(15..8)
    OUT_PORT   : out std_logic_vector(7 downto 0);
    ACC_DEBUG  : out std_logic_vector(7 downto 0);
    HALTED     : out std_logic
);
end entity;

architecture core_arch of cpu_core is
    signal pc_out     : std_logic_vector(3 downto 0);
    signal ir_out     : std_logic_vector(7 downto 0);
    signal acc_out    : std_logic_vector(7 downto 0);
    signal alu_result : std_logic_vector(7 downto 0);
    signal prog_dout  : std_logic_vector(7 downto 0);
    signal data_dout  : std_logic_vector(7 downto 0);

    signal pc_inc, pc_load, ir_load   : std_logic;
    signal acc_load, mem_we, out_load : std_logic;
    signal addr_sel_unused            : std_logic;   -- vestigial, not needed in Harvard
    signal alu_op                     : std_logic_vector(2 downto 0);
    signal zero_flag                  : std_logic;
begin
    zero_flag <= '1' when (acc_out = "00000000") else '0';

    U_PC: entity work.pc_4bit
        port map (CLK => CLK, RESET => RESET, INC => pc_inc, LOAD => pc_load,
                  D => ir_out(3 downto 0), Q => pc_out);

    U_PROG: entity work.prog_mem
        port map (ADDR => pc_out, DOUT => prog_dout);

    U_IR: entity work.register_8bit
        port map (CLK => CLK, RESET => RESET, LOAD => ir_load,
                  D => prog_dout, Q => ir_out);

    U_DATA: entity work.data_mem
        port map (
            CLK => CLK, 
            RESET => RESET, -- NEW: Route the reset signal into memory
            WE => mem_we, 
            ADDR => ir_out(3 downto 0),
            DIN => acc_out, 
            SW_LOW => SW_LOW, 
            SW_HIGH => SW_HIGH,
            DOUT => data_dout
        );

    U_ALU: entity work.alu_8bit
        port map (A => acc_out, B => data_dout, OP => alu_op, RESULT => alu_result);

    U_ACC: entity work.register_8bit
        port map (CLK => CLK, RESET => RESET, LOAD => acc_load,
                  D => alu_result, Q => acc_out);

    U_OUT: entity work.register_8bit
        port map (CLK => CLK, RESET => RESET, LOAD => out_load,
                  D => acc_out, Q => OUT_PORT);

    U_CTRL: entity work.control_unit
        port map (CLK => CLK, RESET => RESET,
                  OPCODE => ir_out(7 downto 4), ZERO => zero_flag,
                  PC_INC => pc_inc, PC_LOAD => pc_load, IR_LOAD => ir_load,
                  ACC_LOAD => acc_load, MEM_WE => mem_we, OUT_LOAD => out_load,
                  ALU_OP => alu_op, ADDR_SEL => addr_sel_unused, HALTED => HALTED);

    ACC_DEBUG <= acc_out;
end core_arch;
