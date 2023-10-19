----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2023 06:02:33
-- Design Name: 
-- Module Name: ALUcontrol - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALUcontrol is
    Port ( funct : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           Operation : out STD_LOGIC_VECTOR (3 downto 0));
end ALUcontrol;

architecture Behavioral of ALUcontrol is

begin

    -- Notes from class
    Operation(3) <= '0';
    Operation(2) <= ALUOp(0) or (ALUOp(1) and funct(1));
    
    Operation(1) <= not ALUOp(1) or not funct(2);
    Operation(0) <= (funct(3) or funct(0)) and ALUOp(1);




end Behavioral;
