library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;
use RISCV.pack_RISCV32I_components.all;

entity RISCV32I_core is
   generic(
      PC_START_ADDRESS : std_logic_vector(32-1 downto 0) := x"0000_0000"
   );
   port(
      --Controls
      reset       : in  std_logic;
      clk         : in  std_logic; 
      enable_PC   : in  std_logic;
      enable_RB   : in  std_logic;
      --Instructions Bus 
      IAddr       : out std_logic_vector(32-1 downto 2); 
      IData       : in  std_logic_vector(32-1 downto 0); 
      --Data Bus
      DBE         : out std_logic_vector( 4-1 downto 0);
      DAddr       : out std_logic_vector(32-1 downto 2); 
      DRead       : out std_logic;
      DWrite      : out std_logic;
      DData_out   : out std_logic_vector(32-1 downto 0);
      DData_in    : in  std_logic_vector(32-1 downto 0)
   );
end entity;

architecture a of RISCV32I_core is

   signal decoded_inst   : tinstruction;
   signal PC             : std_logic_vector(32-1 downto 0);
   signal NPC            : std_logic_vector(32-1 downto 0);
   signal inst           : std_logic_vector(32-1 downto 0);
   signal rs1a           : std_logic_vector( 5-1 downto 0);
   signal rs1d           : std_logic_vector(32-1 downto 0);
   signal rs2a           : std_logic_vector( 5-1 downto 0);
   signal rs2d           : std_logic_vector(32-1 downto 0);
   signal rda            : std_logic_vector( 5-1 downto 0);
   signal rdd            : std_logic_vector(32-1 downto 0);
   signal rdd_select     : integer range 0 to 1;
   signal immI           : std_logic_vector(32-1 downto 0);
   signal immS           : std_logic_vector(32-1 downto 0);
   signal immB           : std_logic_vector(32-1 downto 0);
   signal immU           : std_logic_vector(32-1 downto 0);
   signal immJ           : std_logic_vector(32-1 downto 0);

   signal reg_write      : std_logic;
   
   signal PCrs1d_select  : integer range 0 to 1;
   signal PCrs1d         : std_logic_vector(32-1 downto 0);

   signal imm4BJI_select : integer range 0 to 3;
   signal imm4BJI        : std_logic_vector(32-1 downto 0);

   signal A_select       : integer range 0 to 1;
   signal A              : std_logic_vector(32-1 downto 0);

   signal B_select       : integer range 0 to 4;
   signal B              : std_logic_vector(32-1 downto 0);
   
   signal op             : toperation;
   signal C              : std_logic_vector(32-1 downto 0);

   signal BE             : std_logic_vector( 4-1 downto 0);
   signal data_out       : std_logic_vector(32-1 downto 0);
   signal data_in        : std_logic_vector(32-1 downto 0);
   signal data_in1       : std_logic_vector(32-1 downto 0);
   
   signal addr           : std_logic_vector(32-1 downto 0);
   signal result         : std_logic_vector(32-1 downto 0);

   signal data_read      : std_logic;
   signal data_write     : std_logic;

begin

   --Instruction interface
   IAddr <= PC(31 downto 2);
   inst  <= IData;
   
   --Data interface
   DBE       <= BE;
   Daddr     <= addr(31 downto 2);
   DRead     <= data_read;
   DWrite    <= data_write;
   DData_out <= data_out;
   data_in   <= DData_in;

   --Controller
   U0 : controller
   port map(
      inst          => inst,
      C             => C,
      decoded_inst  => decoded_inst,
      reg_write     => reg_write,
      PCrs1d_select => PCrs1d_select,
      imm4BJI_select=> imm4BJI_select,
      A_select      => A_select,
      B_select      => B_select,
      op            => op,
      data_write    => data_write ,
      data_read     => data_read ,
      rdd_select    => rdd_select
   );
   
   --PC
   process(clk)
   begin
				if (reset = '1')
					then PC <= PC_START_ADDRESS;
					end if;
				if (clk'event and clk = '1')
				then
					if (enable_PC = '1')
						then PC <= NPC;
					else 
						PC <= PC;
					end if;
				end if;
	end process;

   --Decoder
   U1 : Decoder
	  port map(
      inst => inst,
      rs1a => rs1a,
      rs2a => rs2a,
      rda  => rda,
      immI => immI,
      immS => immS,
      immB => immB,
      immU => immU,
      immJ => immJ
   );
   
   --Register bank
	U2 : RegBank
	  port map(
      reset   	   => reset,
      clk          => clk,
      enable       => enable_RB,
      wr           => reg_write,
      address_in   => rda,
      data_in      => rdd,
      address_out1 => rs1a,
      data_out1    => rs1d,
      address_out2 => rs2a,
      data_out2    => rs2d
   );

   --Multiplexors
		
		with PCrs1d_select select
				PCrs1d <= 	PC   when 0,
							rs1d when 1;   
							
		with imm4BJI_select select
				imm4BJI <= 	std_logic_vector(to_unsigned(4,32)) when 0,
							immB 	when 1,
							immJ 	when 2,
							immI 	when 3;
							
		with A_select select
				A		<= rs1d 	when 0,
							PC 		when 1;
							
		with B_select select
				B		<= 	rs2d 	when 0,
							std_logic_vector(to_unsigned(4,32)) when 1,	
							immI 	when 2,
							immS 	when 3,
							immU 	when 4;
							
		with rdd_select select
				rdd 	<=  result 	 when 0,
							data_in1 when 1;
							
   --Arithletic and logic unit
	U3 : ALU 
	port map (
    op => op,
    a  => A,
    b  => B,
    c  => C
	);
	
   --BE generation
	U4 : BE_generator
	   port map(
		  inst    => inst,
		  address => addr(1 downto 0),
		  BE      => BE
	   );
	   
   --Output data formatting
	U5 : output_data_manager 
	 port map (
      inst     => inst,
      data_in  => rs2d,
      data_out => data_out
	);

   --Input data formatting
	U6 : input_data_manager
	port map(
      inst     => inst,
      BE       => BE,
      data_in  => data_in,
      data_out => data_in1
	);
	
   --Result multiplexor
	NPC <= std_logic_vector(unsigned(PCrs1d)+unsigned(imm4BJI));
end a;
