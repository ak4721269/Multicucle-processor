----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.04.2023 13:17:53
-- Design Name: 
-- Module Name: Registers - Behavioral
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


entity Registers is
  Port (clock : in STD_LOGIC;
         inp : in STD_LOGIC_vector(31 downto 0);
         reg_value : out STD_LOGIC_vector(31 downto 0));
end Registers;

architecture Behavioral of Registers is


begin

process(clock)
begin
if (rising_edge(clock)) then 
 reg_value <= inp;
--else
-- reg_value <= (others => '0');
 
 end if;
end process;

end Behavioral;
