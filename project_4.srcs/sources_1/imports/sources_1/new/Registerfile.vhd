library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;





entity Registerfile is
    Generic (
        B : integer := 32;
        W : integer := 5
       );
Port ( clock : in STD_LOGIC; 
       p: in STD_LOGIC;
       pcin : in STD_LOGIC_VECTOR(B-1 downto 0);
       ReadRegister1 : in STD_LOGIC_VECTOR (W-1 downto 0);
       ReadRegister2 : in STD_LOGIC_VECTOR (W-1 downto 0);
       WriteRegister : in STD_LOGIC_VECTOR (W-1 downto 0);
       WriteData : in STD_LOGIC_VECTOR (B-1 downto 0);
       RegWrite : in STD_LOGIC;
       ReadData1 : out STD_LOGIC_VECTOR (B-1 downto 0);
       ReadData2 : out STD_LOGIC_VECTOR (B-1 downto 0);
       pcout : out STD_LOGIC_VECTOR (B-1 downto 0)
       );
       
end Registerfile;

architecture Behavioral of Registerfile is

    type reg_file_type is array(0 to 2**W-1) of    -- 2-D array
        std_logic_vector(B-1 downto 0);



    signal array_reg : reg_file_type := ( x"00000000",     -- $zero
                                          x"00000001",     -- $at
                                          x"00000001",     -- $v0
                                          x"00000001",     -- $v1
                                          x"00000001",     -- $a0
                                          x"00000001",     -- $a1
                                          x"00000001",     -- $a2
                                          x"00000001",     -- $a3
                                          x"00000001",     -- $t0
                                          x"00000001",     -- $t1
                                          x"00000001",     -- $t2
                                          x"00000001",     -- $t3
                                          x"00000001",     -- $t4
                                          x"00000001",     -- $t5
                                          x"00000001",     -- $t6
                                          x"00000001",     -- $t7
                                          x"00000001",     -- $s0
                                          x"00000001",     -- $s1
                                          x"00000001",     -- $s2
                                          x"00000001",     -- $s3
                                          x"00000001",     -- $s4
                                          x"00000001",     -- $s5
                                          x"00000001",     -- $s6
                                          x"00000001",     -- $s7
                                          x"00000001",     -- $t8
                                          x"00000001",     -- $t9
                                          x"00000001",     -- $k0
                                          x"00000001",     -- $k1
                                          x"00000001",     -- $gp
                                          x"00000001",     -- $sp
                                          x"00000001",     -- $fp
                                          x"00000000"     -- $PC
                         
                         );
begin

        process(clock) -- pulse on write 
        begin   
        if(rising_edge(clock))then
             if (p = '1' ) then
                array_reg(31) <= pcin;
            end if;
       
             if (RegWrite = '1' ) then
                array_reg(TO_INTEGER(unsigned(WriteRegister))) <= WriteData;
           --     array_reg(0) <= x"00000000";
            end if;
         end if;
         end process;
         
         
         --read port
         process(readregister1, readregister2)
         begin
         ReadData1 <= array_reg(TO_INTEGER(unsigned(ReadRegister1)));
         ReadData2 <= array_reg(TO_INTEGER(unsigned(ReadRegister2)));
         end process;
         pcout <= array_reg(31);
         
end Behavioral;                
             
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                            


