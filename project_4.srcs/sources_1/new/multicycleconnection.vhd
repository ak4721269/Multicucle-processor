

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity multicycleconnection is
 Port ( clock: in STD_LOGIC;
        rst: in STD_LOGIC );
end multicycleconnection;

architecture Behavioral of multicycleconnection is

    component ALU is
	   Port ( in1 : in STD_LOGIC_VECTOR (31 downto 0);
	       in2 : in STD_LOGIC_VECTOR (31 downto 0);
	       alu_control : in STD_LOGIC_VECTOR (3 downto 0);
	       ALU_result : out STD_LOGIC_VECTOR (31 downto 0);
	       Zero : out STD_LOGIC);
    end component;
            
    component  Registerfile is
        Generic (
        B : integer := 32;
        W : integer := 5
       );
        Port ( clock : in STD_LOGIC; 
               p : in STD_LOGIC;
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
       
        end component;
        
     
            
     component ALUcontrol is
            Port ( funct : in STD_LOGIC_VECTOR (5 downto 0);
                   ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
                   Operation : out STD_LOGIC_VECTOR (3 downto 0));
       end component;
     
    component main_control_multicycle is
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
end component;
       
     component Mux is -- 2-to-1 Mux
	       Generic (
		          N : integer := 32
	           );
	       Port ( mux_in0 : in STD_LOGIC_VECTOR(N-1 downto 0);
	              mux_in1 : in STD_LOGIC_VECTOR(N-1 downto 0);
		          mux_ctrl1 : in STD_LOGIC;
		          mux_output : out STD_LOGIC_VECTOR(N-1 downto 0)
	       );
        end component;
        
     component SignExtend is
	   Port( se_in : in STD_LOGIC_VECTOR(15 downto 0);
		     se_out : out STD_LOGIC_VECTOR(31 downto 0)
            );
         end component;
         
     
    component Registers is
       Port (clock : in STD_LOGIC;
         inp : in STD_LOGIC_vector(31 downto 0);
         reg_value : out STD_LOGIC_vector(31 downto 0));
    end component;
    
 



    component Instruction_register is
        Port ( clock : IN STD_LOGIC;
        rst : in std_logic;
        input : IN STD_LOGIC_VECTOR(31 downto 0);
        IRWrite : IN STD_LOGIC;
        Instruction : OUT STD_LOGIC_vector(31 downto 0));
        
    end component;
    
    component mux4to1 is
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
end component;

      component  memory is
  Port ( clk : in STD_LOGIC ;
         Address : in STD_LOGIC_VECTOR (31 downto 0);
         WriteData : in STD_LOGIC_VECTOR (31 downto 0);
        MemRead : in STD_LOGIC;
         MemWrite : in STD_LOGIC; 
         ReadData : out STD_LOGIC_VECTOR (31 downto 0));
end component;
      
  
    
     
     
    signal instruction : std_logic_vector(31 downto 0);
    signal memread : std_logic;
    signal pc : std_logic_vector(31 downto 0) ;
    signal regdst : std_logic;
    signal alusrc : std_logic;
    signal regwrite : std_logic;
    signal mux1_output : std_logic_vector(31 downto 0);
    signal memtoreg : std_logic;
    signal aluop : std_logic_vector(1 downto 0);
    signal memwrite : std_logic;
    signal readdata1 : std_logic_vector(31 downto 0);
    signal readdata2 : std_logic_vector(31 downto 0);
    
    signal ext_sign_data : std_logic_vector(31 downto 0);
    signal mux2_output : std_logic_vector(4 downto 0);
    signal operation : std_logic_vector(3 downto 0);
    signal aluresult1 : std_logic_vector(31 downto 0);
    signal zero : std_logic;
    signal jump_address : std_logic_vector(31 downto 0);
    signal mux_5_output : std_logic_vector(31 downto 0);
    signal mem_readdata : std_logic_vector(31 downto 0);
    signal mux3_output : std_logic_vector(31 downto 0);
    signal effective_address : std_logic_vector(31 downto 0);
    signal shift_extended_sign_value : std_logic_vector(31 downto 0);
    signal mux4_output : std_logic_vector(31 downto 0);
    signal mux5_output : std_logic_vector(31 downto 0);
    signal mux6_output : std_logic_vector(31 downto 0);
    signal multiplx4_ctl : std_logic;
    signal aluout : std_logic_vector( 31 downto 0);  --new
    signal IorD : std_logic; --new
    signal B: std_logic_vector(31 downto 0); --new
    signal reg_value:  std_logic_vector(31 downto 0); --new
    signal IRWrite : std_logic;
    signal PC_OUTPUT : std_logic;
    signal MDROUT : std_logic_vector(31 downto 0);
    signal Aout : std_logic_vector(31 downto 0);
    signal ReadData: std_logic_vector(31 downto 0);
    signal PCwriteCond: std_logic;
    signal PCwrite: std_logic;
    signal PCSource: std_logic_vector(1 downto 0);
    signal RegDest: std_logic;
    signal ALUSrcA: std_logic;
    signal ALUSrcB: std_logic_vector(1 downto 0);
    
    signal const: std_logic_vector(31 downto 0) := (others => '0');
    signal constzero: std_logic_vector(31 downto 0) := (others => '0');
    
    signal op1: std_logic;
    
    signal op2: std_logic;



begin


-- PCReg: Registers port map(
--    clock => clock,
--         inp => pc,
--         reg_value => reg_value
--         );
         
   
    
        
 multiplx1 : MUX generic map ( N => 32 ) port map (
        mux_in0 => pc,
        mux_in1 => ALUout,
        mux_ctrl1 => IorD,
        mux_output => mux1_output
    ); 
    
 main_memory : memory port map(
           clk => clock,
         Address => mux1_output,
         WriteData => B,
        MemRead => MemRead,
         MemWrite => MemWrite, 
         ReadData => ReadData
         );
    
    
 main_control : main_control_multicycle port map (
           OpCode => Instruction(31 downto 26),
           clock => clock,
           rst => rst,
           PCWriteCond => PCwriteCond, 
           PCWrite => PCWrite,
           IorD => IorD,
           IRWrite => IRWrite,
           PCSource => PCSource(1 downto 0), 
           RegDest => RegDest,
           MemRead => MemRead,
           MemToReg => MemToReg,
           ALUOp => ALUOp (1 downto 0),
           MemWrite => MemWrite, 
           ALUSrcA => ALUSrcA , 
           ALUSrcB => ALUSrcB(1 downto 0), 
           RegWrite => RegWrite
    );
    
 Instr_reg : Instruction_register port map (
           clock => clock,
           rst => rst,
        input => ReadData,
        IRWrite => IRWrite,
        Instruction => Instruction
        );
        
 MDR : Registers port map (
          clock => clock,
         inp => ReadData,
         reg_value => MDROUT
         );
         
 multiplx2 : MUX generic map ( N => 5 ) port map (
        mux_in0 => Instruction(20 downto 16),
        mux_in1 => Instruction(15 downto 11),
        mux_ctrl1 => RegDest,
        mux_output => mux2_output
    ); 
         
          
 multiplx3 : MUX generic map ( N => 32 ) port map (
        mux_in0 => ALUout,
        mux_in1 => MDROUT,
        mux_ctrl1 => MemToReg,
        mux_output => mux3_output
    ); 
    
       
     op1 <= PCWriteCond and zero;
     op2 <= PCWrite or op1;
            
 reg_file : Registerfile port map (  -- need to implement pclogic before this
                clock => clock,
               p => op2,
               pcin => mux6_output,
               ReadRegister1 => Instruction (25 downto 21),
               ReadRegister2 => Instruction (20 downto 16),
               WriteRegister => mux2_output,
               WriteData => mux3_output,
               RegWrite => RegWrite,
               ReadData1 => ReadData1,
               ReadData2 => ReadData2,
               pcout =>pc 
               );
               
               
 Areg : Registers port map (
              clock => clock,
         inp => ReadData1,
         reg_value => Aout
         );
         
 Breg : Registers port map (
              clock => clock,
         inp => ReadData2,
         reg_value => B
         );
         
  sign_extender : SignExtend port map (
        se_in => instruction(15 downto 0),
        se_out => ext_sign_data
    );
    
  shift_extended_sign_value <= std_logic_vector(shift_left(unsigned(ext_sign_data), 2));
         
         
  multiplx4 : MUX generic map ( N => 32 ) port map ( -- need to use pc logic here as well
        mux_in0 => pc,
        mux_in1 => Aout,
        mux_ctrl1 => alusrca,
        mux_output => mux4_output
    );  
    
    const <= std_logic_vector(to_unsigned(4,32));
    
  multiplx5 : MUX4to1 generic map (N => 32) port map ( --need to add shift left logic
        mux_in0 => B,
        mux_in1 => const,
        mux_in2 => ext_sign_data,
        mux_in3 => shift_extended_sign_value, -- need to check here
        mux_ctrl1 => ALUSrcB(1),
        mux_ctrl2 => ALUSrcB(0),
        mux_output => mux5_output
        );
        
   alu_control : AluControl port map (
        funct => instruction(5 downto 0),
        AluOp => aluop,
        Operation => operation
    );
    
   
    main_alu : ALU port map (
        in1 => mux4_output,
        in2 => mux5_output,
        alu_control => operation,
        ALU_result => aluresult1,
        Zero => zero
    );   
    
     ALUOUTP : Registers port map (
              clock => clock,
         inp => aluresult1,
         reg_value => ALUOut
         ); 
         
     jump_address <= std_logic_vector(shift_left(unsigned("00" & instruction(25 downto 0)),2)) & pc(31 downto 28); --need to modify here
         
     multiplx6 : MUX4to1 generic map (N => 32) port map ( --need to add shift left logic
        mux_in0 => aluresult1,
        mux_in1 => ALUOut,
        mux_in2 => jump_address,
        mux_in3 => constzero, -- need to check here
        mux_ctrl1 => PCSource(1),
        mux_ctrl2 => PCSource(0),
        mux_output => mux6_output
        ); 
   
         
     
  
   
   
    
   
  
        
     
         
               
               
        
           
    
 
    


end Behavioral;
