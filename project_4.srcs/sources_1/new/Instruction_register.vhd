


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Instruction_register is
 Port ( clock : IN STD_LOGIC;
        rst : in STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(31 downto 0);
        IRWrite : IN STD_LOGIC;
        Instruction : OUT STD_LOGIC_vector(31 downto 0));
        
end Instruction_register;

architecture Behavioral of Instruction_register is

begin

process(clock, rst)
begin
if (rst = '1')then
Instruction <= (others => '0');
elsif(rising_edge(clock) and IRwrite = '1') then
Instruction <= input;
END IF;
end process;




end Behavioral;
