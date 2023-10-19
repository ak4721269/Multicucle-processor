library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	Port ( in1 : in STD_LOGIC_VECTOR (31 downto 0);
	       in2 : in STD_LOGIC_VECTOR (31 downto 0);
	       alu_control : in STD_LOGIC_VECTOR (3 downto 0);
	       ALU_result : out STD_LOGIC_VECTOR (31 downto 0);
	       Zero : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

    signal resultX : std_logic_vector(31 downto 0);

begin


	process(in1, in2, alu_control)
	begin
	
	case alu_control is
	
		when "0000" => --Bitwise And
			resultX <= in1 and in2;
		
		when "0001" => --Bitwise Or
			resultX <= in1 or in2;
			
		when "0010" => --Addition
			resultX <= std_logic_vector(unsigned(in1) + unsigned(in2));
			
		when "0110" => --Subtraction
			resultX <= std_logic_vector(unsigned(in1) - unsigned(in2));
			
		when others => null; -- Nop
		
			resultX <= x"00000000";
		
	    end case;	
	
	end process;
	
	-- Concurrent Code
	ALU_result <= resultX;
	Zero <= '1' when resultX = x"00000000" else
		'0';

end Behavioral;
