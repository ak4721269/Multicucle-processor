library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( OpCode : in STD_LOGIC_VECTOR (5 downto 0); -- Instruction31-26
           RegDest : out STD_LOGIC;
           Jump : out STD_LOGIC;
           Branch : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end Controller;

architecture Behavioral of Controller is

begin

    process(OpCode)
    begin
    
        RegWrite <= '0';  -- Deassert for next command
        
        case OpCode is     
        
            when "000000" => -- And, Or, Add, Sub: 0x00
                RegDest <= '1';
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemToReg <= '0';
                ALUOp <= "10";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '1';
                
            when "100011" => -- Load Word(lw): 0x23
                RegDest <= '0';
                Jump <= '0';
                Branch <= '0';
                MemRead <= '1';
                MemToReg <= '1';
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrc <= '1';
                RegWrite <= '1' after 10 ns;
                
            when "101011" => -- Store Word(sw): 0x28
                RegDest <= '0';   -- Don't care
                Jump <= '0';
                Branch <= '0' after 2 ns ; 
                MemRead <= '0';
                MemToReg <= 'X';  -- Don't care
                ALUOp <= "00";
                MemWrite <= '1';
                ALUSrc <= '1';
                RegWrite <= '0';
                
             when "000100" => -- Branch Equal(beq): 0x04
                RegDest <= 'X'; -- Don't care
                Jump <= '0';
                Branch <= '1' after 2 ns ; 
                MemRead <= '0';
                MemToReg <= 'X'; -- Don't care
                ALUOp <= "01";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '0';
                
             when "000010" => -- Jump(j): 0x02
                RegDest <= 'X'; -- Don't care
                Jump <= '1';
                Branch <= '0' ; 
                MemRead <= '0';
                MemToReg <= 'X'; -- Don't care
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '0';
                
             when others => null; -- Implement other commands down here
                RegDest <= '0'; --Don't Care
                Jump <= '0';
                Branch <= '0'; 
                MemRead <= '0';
                MemToReg <= '0'; --Don't care
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '0';
                
                
             end case;
             
        end process;
        
                
end Behavioral;