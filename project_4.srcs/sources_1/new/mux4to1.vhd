


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity mux4to1 is
 Generic (
		N : integer := 32
	);
	Port ( mux_in0 : in STD_LOGIC_VECTOR(N-1 downto 0);
	       mux_in1 : in STD_LOGIC_VECTOR(N-1 downto 0);
	       mux_in2 : in STD_LOGIC_VECTOR(N-1 downto 0);
	       mux_in3 : in STD_LOGIC_VECTOR(N-1 downto 0);
		   mux_ctrl1 : in STD_LOGIC;
		   mux_ctrl2 : in STD_LOGIC;
		 mux_output : out STD_LOGIC_VECTOR(N-1 downto 0)
	); 
end mux4to1;

architecture Behavioral of mux4to1 is

begin

process(mux_ctrl1,mux_ctrl2,mux_in0,mux_in1,mux_in2,mux_in3)
begin
if(mux_ctrl1 = '0' and mux_ctrl2 = '0') then
mux_output <= mux_in0 ;
end if;
if(mux_ctrl1 = '0' and mux_ctrl2 = '1') then
mux_output <= mux_in1 ;
end if;
if(mux_ctrl1 = '1' and mux_ctrl2 = '0') then
mux_output <= mux_in2 ;
end if;
if(mux_ctrl1 = '1' and mux_ctrl2 = '1') then
mux_output <= mux_in3 ;
end if;

end process;

end Behavioral;
