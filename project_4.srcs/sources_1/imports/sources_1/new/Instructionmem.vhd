


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Instructionmem is
    Port ( ReadAddress : in STD_LOGIC_VECTOR (31 downto 0);
           Instruction : out STD_LOGIC_VECTOR (31 downto 0));
end Instructionmem;

                        
architecture Behavioral of Instructionmem is

type instr_mem is array(63 downto 0) of std_logic_vector(7 downto 0);
signal instruction_memory : instr_mem := ( 0 => x"8c", -- lw $s0 0($zero)         0x8c100000    
                                         1 => x"10", 
                                         2 => x"00",
                                         3 => x"00",
                                         4 => x"8c",  -- lw $s1 4($zero)           0x8c090004
                                         5 => x"11",
                                         6 => x"00",
                                         7 => x"04",
                                         8 => x"02", -- add $t0, $s0, $s1         0x02114020 
                                         9 => x"11",
                                         10 => x"40",
                                         11 => x"20",
                                         12 => x"02", -- sub $t1,$s1,$s0          0x02304822  0x02114822
                                         13 => x"11",
                                         14 => x"48",
                                         15 => x"22",
                                         16 => x"02", -- slt $t2, $s0, $s1        0x0211502A
                                         17 => x"11",
                                         18 => x"50",
                                         19 => x"2A",
                                         20 => x"ac", -- sw $t0, 8($zero)         0xac080008
                                         21 => x"08",
                                         22 => x"00",
                                         23 => x"08",
                                         24 => x"ac", -- sw $t1, 12($zero)        0xac09000c
                                         25 => x"09",
                                         26 => x"00",
                                         27 => x"0c",
                                         28 => x"8c", -- lw $s2, 8($zero)         0x8c120008
                                         29 => x"12",
                                         30 => x"00",
                                         31 => x"08",
                                         32 => x"8c", -- lw $s3, 12($zero)        0x8c13000C
                                         33 => x"13",
                                         34 => x"00",
                                         35 => x"0c",
                                         36 => x"02", -- and $t3, $s2, $s3        0x02535824
                                         37 => x"53",
                                         38 => x"58",
                                         39 => x"24",
                                         44 => x"02", -- or $t4, $s2, $s3         0x02536025 
                                         45 => x"53",
                                         46 => x"60",
                                         47 => x"25",
                                         48 => x"11", -- beq $t2, $zero, 1        0x11400001
                                         49 => x"40",
                                         50 => x"00",
                                         51 => x"01",
                                         52 => x"02", -- add $s4,$s0,$s1           0x0211A020
                                         53 => x"11",
                                         54 => x"A0",
                                         55 => x"20",
                                         56 => x"08",    --j 0                     0x08000000
                                         57 => x"00",
                                         58 => x"00",
                                         59 => x"00",
                                         others => x"00");
begin
process(ReadAddress)
    begin
        Instruction(31 downto 0) <=  instruction_memory(conv_integer(ReadAddress)) & 
                                 instruction_memory(conv_integer(ReadAddress)+1) & 
                                 instruction_memory(conv_integer(ReadAddress)+2) & 
                                 instruction_memory(conv_integer(ReadAddress)+3);
                                
        -- here the value of current pc is converted to integer and concatenated with the next byte till we reach the next instuction 
           --after covering the next 3 bytes 
end process;
end Behavioral;                                


