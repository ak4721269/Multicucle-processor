----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2023 14:02:35
-- Design Name: 
-- Module Name: connection - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity connection is
   Port ( clock: in STD_LOGIC ;
            rst: out STD_LOGIC );
end connection;

architecture Behavioral of connection is

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
        
     component Instructionmem is
            Port ( ReadAddress : in STD_LOGIC_VECTOR (31 downto 0);
                 Instruction : out STD_LOGIC_VECTOR (31 downto 0));
            end component;
            
            
     component ALUcontrol is
            Port ( funct : in STD_LOGIC_VECTOR (5 downto 0);
                   ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
                   Operation : out STD_LOGIC_VECTOR (3 downto 0));
       end component;
       
     component Controller is
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
         
     component Datamem is
        Port ( 
               clk : in STD_LOGIC;                                         
               Address : in STD_LOGIC_VECTOR (31 downto 0);
               WriteData : in STD_LOGIC_VECTOR (31 downto 0);
               MemRead : in STD_LOGIC;
               MemWrite : in STD_LOGIC; 
                ReadData : out STD_LOGIC_VECTOR (31 downto 0));
      end component;
      
    
     
     
    signal instruction : std_logic_vector(31 downto 0);
    signal jmp : std_logic;
    signal branch : std_logic;
    signal memread : std_logic;
    signal pc : std_logic_vector(31 downto 0) ;
    signal nextpc_value : std_logic_vector(31 downto 0);
    signal regdst : std_logic;
    signal alusrc : std_logic;
    signal regwrite : std_logic;
    signal mux1_output : std_logic_vector(4 downto 0);
    signal memtoreg : std_logic;
    signal aluop : std_logic_vector(1 downto 0);
    signal memwrite : std_logic;
    signal readdata1 : std_logic_vector(31 downto 0);
    signal readdata2 : std_logic_vector(31 downto 0);
    signal ext_sign_data : std_logic_vector(31 downto 0);
    signal mux2_output : std_logic_vector(31 downto 0);
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
    signal multiplx4_ctl : std_logic;
  
    
begin
    
    instruction_mem : Instructionmem port map (
        ReadAddress => pc,
        Instruction => instruction 
    );
    
    main_control : Controller port map (
        OpCode => instruction(31 downto 26),
        RegDest => regdst,
        Jump => jmp, 
        Branch => branch,
        MemRead => memread,
        MemToReg => memtoreg,
        ALUOp => aluop,
        MemWrite => memwrite,
        ALUSrc => alusrc,
        RegWrite => regwrite
    );
    
    multiplx1 : MUX generic map ( N => 5 ) port map (
        mux_in0 => instruction(20 downto 16),
        mux_in1 => instruction(15 downto 11),
        mux_ctrl1 => regdst,
        mux_output => mux1_output
    ); 
    
    register_file : RegisterFile port map (
        clock => clock ,
        pcin => mux_5_output ,
        pcout => pc,
        ReadRegister1 => instruction(25 downto 21),
        ReadRegister2 => instruction(20 downto 16),
        WriteRegister => mux1_output,
        WriteData => mux3_output,    -- After making data memory update
        RegWrite => regwrite,
        ReadData1 => readdata1,
        ReadData2 => readdata2
    );
    
    sign_extender : SignExtend port map (
        se_in => instruction(15 downto 0),
        se_out => ext_sign_data
    );
    
    multiplx2 : MUX generic map ( N => 32 ) port map (
        mux_in0 => readdata2,
        mux_in1 => ext_sign_data,
        mux_ctrl1 => alusrc,
        mux_output => mux2_output
    );
    
    alu_control : AluControl port map (
        funct => instruction(5 downto 0),
        AluOp => aluop,
        Operation => operation
    );
    
    main_alu : ALU port map (
        in1 => readdata1,
        in2 => mux2_output,
        alu_control => operation,
        ALU_result => aluresult1,
        Zero => zero
    );
    
    data_memory : Datamem port map(
           clk => clock, 
           Address=> aluresult1,
           WriteData => readdata2,
           MemRead => memread,
           MemWrite => memwrite,
           ReadData => mem_readdata
    );
    
    multiplx3 : MUX generic map ( N => 32 ) port map (
        mux_in0 => aluresult1,
        mux_in1 => mem_readdata,
        mux_ctrl1 => memtoreg,
        mux_output => mux3_output
    );
    
    
    nextpc_value <= std_logic_vector(unsigned(pc) + 4);
  
    shift_extended_sign_value <= std_logic_vector(shift_left(unsigned(ext_sign_data), 2));
    effective_address <= std_logic_vector(unsigned(nextpc_value) + unsigned(shift_extended_sign_value));
      
    multiplx4_ctl <= branch and zero;
    
    multiplx4 : MUX generic map ( N => 32 ) port map (
        mux_in0 => nextpc_value,
        mux_in1 => effective_address,
        mux_ctrl1 => multiplx4_ctl,
        mux_output => mux4_output
        );
        
    jump_address <= std_logic_vector(shift_left(unsigned("00" & instruction(25 downto 0)),2)) & nextpc_value(31 downto 28);
        
    multiplx5 : MUX generic map ( N => 32 ) port map (
        mux_in0 =>mux4_output,
        mux_in1 => jump_address,
        mux_ctrl1 => jmp,
        mux_output => mux_5_output
        );
end Behavioral;
        
        
        
        
             
   
