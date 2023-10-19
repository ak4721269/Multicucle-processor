library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is -- 2-to-1 Mux
	Generic (
		N : integer := 32
	);
	Port ( mux_in0 : in STD_LOGIC_VECTOR(N-1 downto 0);
	       mux_in1 : in STD_LOGIC_VECTOR(N-1 downto 0);
		 mux_ctrl1 : in STD_LOGIC;
		 mux_output : out STD_LOGIC_VECTOR(N-1 downto 0)
	);
end Mux;

architecture Behavioral of Mux is

begin 

	mux_output <= mux_in0 when mux_ctrl1 = '0' else
		     mux_in1;

end Behavioral;
