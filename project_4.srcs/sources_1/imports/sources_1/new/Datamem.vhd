----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2023 05:25:54
-- Design Name: 
-- Module Name: Datamem - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Datamem is
  Port ( clk : in STD_LOGIC ;
         Address : in STD_LOGIC_VECTOR (31 downto 0);
         WriteData : in STD_LOGIC_VECTOR (31 downto 0);
         MemRead : in STD_LOGIC;
         MemWrite : in STD_LOGIC; 
         ReadData : out STD_LOGIC_VECTOR (31 downto 0));
end Datamem;

architecture Behavioral of Datamem is

type data_mem is array(63 downto 0) of std_logic_vector(7 downto 0);
signal data_memory : data_mem := ( 0 => x"00",
                                         1 => x"00",
                                         2 => x"00",
                                         3 => x"04",
                                         4 => x"00",
                                         5 => x"00",
                                         6 => x"00",
                                         7 => x"02",
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
              if(MemWrite <= '1')then
          data_memory(conv_integer(Address)) <= WriteData(31 downto 24);
          data_memory(conv_integer(Address)+1) <= WriteData(23 downto 16);
          data_memory(conv_integer(Address)+2) <= WriteData(15 downto 8);
          data_memory(conv_integer(Address)+3) <= WriteData(7 downto 0);
         
         end if;
       end if;
end process;
    
     
end Behavioral;
