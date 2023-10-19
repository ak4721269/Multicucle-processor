----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2023 12:12:25
-- Design Name: 
-- Module Name: main_control_multicycle - Behavioral
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

entity main_control_multicycle is
  Port    ( OpCode : in STD_LOGIC_VECTOR (5 downto 0); -- Instruction31-26
           clock : in STD_LOGIC;
           rst : in STD_LOGIC;
           PCWriteCond : out STD_LOGIC; 
           PCWrite : out STD_LOGIC;
           IorD : out STD_LOGIC;
           IRWrite : out STD_LOGIC;
           PCSource : out  STD_LOGIC_VECTOR (1 downto 0);  
           RegDest : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;  
           ALUSrcA : out STD_LOGIC ;  --
           ALUSrcB : out STD_LOGIC_VECTOR (1 downto 0);  --
           RegWrite : out STD_LOGIC);
end main_control_multicycle;

architecture Behavioral of main_control_multicycle is

signal PresentState : STD_LOGIC_VECTOR (3 downto 0);

signal NextState : STD_LOGIC_VECTOR (3 downto 0);


begin

process(clock,rst)
begin
if(rst = '1')then
        PresentState <= "0000";
elsif(rising_edge(clock))then
    PresentState <= NextState;
end if;
end process;


  process(PresentState,OpCode)
   begin
    
      --  RegWrite <= '0';  -- Deassert for next command
      
--        if(rising_edge(clock))then
          --  NextState <= PresentState;
              if ( PresentState = "0000") then
                NextState <= "0001";
                
                end if;
            
             if ( PresentState = "0001" AND (OpCode = "100011" OR OpCode = "101011") ) then  -- lw,sw
                NextState <= "0010";
                
                end if;
                
            if( PresentState = "0010" AND OpCode = "100011") then --lw
                NextState <= "0011";
                
                end if;
                
             if( PresentState = "0010" AND OpCode = "101011") then  --sw
                NextState <= "0101";
                
                end if;
                
             if( PresentState = "0001" AND OpCode = "000000") then  --R-type
                NextState <= "0110";
                
                end if;
                
             if( PresentState = "0001" AND OpCode = "000100") then  --beq
                NextState <= "1000";
                
                end if;
                
             if( PresentState = "0001" AND OpCode = "000010") then  --Jump
                NextState <= "1001";
                
                end if; 
                
             if( PresentState = "0011") then   -- Write back stage
                NextState <= "0100";
                
                end if;      
                
             if( PresentState = "0100") then   -- Write back stage
                NextState <= "0000";
                
                end if;     
                
             if( PresentState = "0101") then   -- Write back stage
                NextState <= "0000";
                
                end if;    
                
             if( PresentState = "0110") then   -- Write back stage
                NextState <= "0111";
                
                end if;   
                
             if( PresentState = "0111") then   -- Write back stage
                NextState <= "0000";
                
                end if;   
                
              if( PresentState = "1000") then   -- Write back stage
                NextState <= "0000";
                
                end if;    
                
              if( PresentState = "1001") then   -- Write back stage
                NextState <= "0000";
                
                end if;   
                    
                  
                
       --   PresentState <= NextState;   
            
   --      end if;
        
        
        
        case PresentState is     
        
            when "0000" => -- And, Or, Add, Sub: 0x00
                RegDest <= '0';
                MemRead <= '1';
                MemToReg <= '0';
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "01";
                RegWrite <= '1';
                PCWriteCond <= '0'; 
                PCWrite <= '1';
                IorD <= '0';
                IRWrite <= '1';
                PCSource <= "00";               
               
                
                
            when "0001" => -- Sub: 0x00
                RegDest <= '0';
                MemRead <= '0';
                MemToReg <= '0';
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "11";
                RegWrite <= '0';
                PCWriteCond <= '0'; 
                PCWrite <= '0';
                IorD <= '0';
                IRWrite <= '0';
                PCSource <= "00";               
               

                
            when "0010" => -- Load Word(lw): 0x23
                RegDest <= '0';
                MemRead <= '0';
                MemToReg <= '0';
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                RegWrite <= '0' after 10 ns;
                PCWriteCond <= '0'; 
                PCWrite <= '0';
                IorD <= '0';
                IRWrite <= '0';
                PCSource <= "00"; 

                
            when "0011" => -- Store Word(sw): 0x28
                RegDest <= '0';   -- Don't care
                MemRead <= '1';
                MemToReg <= '0';  -- Don't care
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "00";
                RegWrite <= '0' after 10 ns;
                PCWriteCond <= '0'; 
                PCWrite <= '0';
                IorD <= '1';
                IRWrite <= '0';
                PCSource <= "00";               
               

                
             when "0100" => -- Branch Equal(beq): 0x04
                RegDest <= '0'; -- Don't care
                MemRead <= '0';
                MemToReg <= '1'; -- Don't care
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "00";
                RegWrite <= '1';
                PCWriteCond <= '0' ; 
                PCWrite <= '0';
                IorD <= '0';
                IRWrite <= '0';
                PCSource <= "00";               
               

                
             when "0101" => -- Jump(j): 0x02
                RegDest <= '0'; -- Don't care
                MemRead <= '0';
                MemToReg <= '0'; -- Don't care
                ALUOp <= "00";
                MemWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= "01";
                RegWrite <= '0';
                PCWriteCond <= '0'; 
                PCWrite <= '0';
                IorD <= '1';
                IRWrite <= '0';
                PCSource <= "00"; 
                
                
             when "0110" => -- Jump(j): 0x02
                RegDest <= '0'; -- Don't care
                MemRead <= '0';
                MemToReg <= '0'; -- Don't care
                ALUOp <= "10";
                MemWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                RegWrite <= '0';
                PCWriteCond <= '0'; 
                PCWrite <= '0';
                IorD <= '0';
                IRWrite <= '0';
                PCSource <= "00";   
                
            when "0111" => -- Jump(j): 0x02
                RegDest <= '1'; -- Don't care
                MemRead <= '0';
                MemToReg <= '0'; -- Don't care
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                RegWrite <= '1';
                PCWriteCond <= '0'; 
                PCWrite <= '0';
                IorD <= '0';
                IRWrite <= '0';
                PCSource <= "00";    
                
                
        
                
           when "1000" =>
                RegDest <= '0'; -- Don't care
                MemRead <= '0';
                MemToReg <= '0'; -- Don't care
                ALUOp <= "01";
                MemWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "00";
                RegWrite <= '0';
                PCWriteCond <= '1'; 
                PCWrite <= '0';
                IorD <= '0';
                IRWrite <= '0';
                PCSource <= "01";     
                
                
           when "1001" =>
                RegDest <= '0'; -- Don't care
                MemRead <= '0';
                MemToReg <= '0'; -- Don't care
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "00";
                RegWrite <= '0';
                PCWriteCond <= '0'; 
                PCWrite <= '1';
                IorD <= '0';
                IRWrite <= '0';
                PCSource <= "10";  
                      
               

                
             when others => null; -- Implement other commands down here
                RegDest <= '0'; --Don't Care
                MemRead <= '0';
                MemToReg <= '0'; --Don't care
                ALUOp <= "00";
                MemWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "00";
                RegWrite <= '0';
                PCWriteCond <= '0'; 
                PCWrite <= '0';
                IorD <='0';
                IRWrite <= '0';
                PCSource <= "00";               
               
               
               

                
                
             end case;
             
        end process;
        
                
end Behavioral;
