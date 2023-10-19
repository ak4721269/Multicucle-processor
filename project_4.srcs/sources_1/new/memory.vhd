----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.04.2023 19:38:49
-- Design Name: 
-- Module Name: memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity memory is
  Port ( clk : in STD_LOGIC ;
         Address : in STD_LOGIC_VECTOR (31 downto 0);
         WriteData : in STD_LOGIC_VECTOR (31 downto 0);
        MemRead : in STD_LOGIC;
         MemWrite : in STD_LOGIC; 
         ReadData : out STD_LOGIC_VECTOR (31 downto 0));
end memory;

architecture Behavioral of memory is

type data_mem is array(1023 downto 0) of std_logic_vector(7 downto 0);
signal data_memory : data_mem := ( 0 => x"8c", -- lw $s0 60($zero)         0x8c10003c    
                                         1 => x"10", 
                                         2 => x"00",
                                         3 => x"3c",
                                         4 => x"8c",  -- lw $s1 64($zero)           0x8c090004
                                         5 => x"11",
                                         6 => x"00",
                                         7 => x"40",
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
                                         23 => x"44",
                                         24 => x"ac", -- sw $t1, 12($zero)        0xac09000c
                                         25 => x"09",
                                         26 => x"00",
                                         27 => x"48",
                                         28 => x"8c", -- lw $s2, 68($zero)         0x8c120008
                                         29 => x"12",
                                         30 => x"00",
                                         31 => x"44",
                                         32 => x"8c", -- lw $s3, 72($zero)        0x8c13000C
                                         33 => x"13",
                                         34 => x"00",
                                         35 => x"48",
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
                                         60 => x"00",
                                         61 => x"00",
                                         62 => x"00",
                                         63 => x"04",
                                         64 => x"00",
                                         65 => x"00",
                                         66 => x"00",
                                         67 => x"02",
                                         68 => x"00",
                                         69 => x"00",
                                         70 => x"00",
                                         71 => x"05",
                                          others => x"00");
                                        
                                         

begin

ReadData <= data_memory(conv_integer(Address)) & 
                      data_memory(conv_integer(Address)+1) &
                       data_memory(conv_integer(Address)+2) &
                       data_memory(conv_integer(Address)+3) when (MemRead ='1') else x"00000000";
                       
                       -- 8 bit memory based on read memory signal take 4 bytes concatenate to read
                       -- data from data memory
                       
process(clk)
begin                      
       if(rising_edge(clk))then
              if(MemWrite = '1')then
          data_memory(conv_integer(Address)) <= WriteData(31 downto 24);
          data_memory(conv_integer(Address)+1) <= WriteData(23 downto 16);
          data_memory(conv_integer(Address)+2) <= WriteData(15 downto 8);
          data_memory(conv_integer(Address)+3) <= WriteData(7 downto 0);
         
         end if;
       end if;
end process;
    
    


end Behavioral;
