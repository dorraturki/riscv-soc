library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV;
use RISCV.pack_RISCV32I_components.all;

library memory;
use memory.pack_memory_components.all;

library uart;
use uart.pack_uart_components.all;

library gpio;
use gpio.pack_gpio_components.all;

library copro;
use copro.pack_copro_components.all;

library soc;
use soc.pack_axi_types.all;
use soc.pack_soc_components.all;

entity system is
   generic(
      PC_START_ADDRESS    : std_logic_vector(32-1 downto 0) := x"0000_0000";
      SIMULATION          : boolean                         := false;
      TRACE               : boolean                         := true;
      PROGRAM_FILE_NAME   : string                          := "I0.mem";
      CONSTANTS_FILE_NAME : string                          := "D1.mem"
   );
   port(
      reset  : in std_logic;
      clk    : in std_logic;
      enable : in  std_logic;
	  RX : in std_logic;
	  TX : out std_logic;
	  data_in  : in  std_logic_vector(32-1 downto 0);
      data_out : out std_logic_vector(32-1 downto 0);
	  pixel_in  : in  std_logic_vector(32-1 downto 0);
      pixel_out : out std_logic_vector(32-1 downto 0)
   );
end entity;

architecture a of system is

   --CPU0
   --Instruction channels
   ----Read command
   signal CPU0_inst_ARvalid : std_logic;
   signal CPU0_inst_ARready : std_logic;
   signal CPU0_inst_ARpayld : tARpayld;
   ----Read data
   signal CPU0_inst_Rvalid  : std_logic;
   signal CPU0_inst_Rready  : std_logic;
   signal CPU0_inst_Rpayld  : tRpayld;
   ----Write command
   signal CPU0_inst_AWvalid : std_logic;
   signal CPU0_inst_AWready : std_logic;
   signal CPU0_inst_AWpayld : tAWpayld;
   ----Write data
   signal CPU0_inst_Wvalid  : std_logic;
   signal CPU0_inst_Wready  : std_logic;
   signal CPU0_inst_Wpayld  : tWpayld;
   ----Write response
   signal CPU0_inst_Bvalid  : std_logic;
   signal CPU0_inst_Bready  : std_logic;
   signal CPU0_inst_Bpayld  : tBpayld;

   --Data Read channels
   ----Read command
   signal CPU0_data_ARvalid : std_logic;
   signal CPU0_data_ARready : std_logic;
   signal CPU0_data_ARpayld : tARpayld;
   ----Read data
   signal CPU0_data_Rvalid  : std_logic;
   signal CPU0_data_Rready  : std_logic;
   signal CPU0_data_Rpayld  : tRpayld;
   --Data Write channels
   ----Write command
   signal CPU0_data_AWvalid : std_logic;
   signal CPU0_data_AWready : std_logic;
   signal CPU0_data_AWpayld : tAWpayld;
   ----Write data
   signal CPU0_data_Wvalid  : std_logic;
   signal CPU0_data_Wready  : std_logic;
   signal CPU0_data_Wpayld  : tWpayld;
   ----Write response
   signal CPU0_data_Bvalid  : std_logic;
   signal CPU0_data_Bready  : std_logic;
   signal CPU0_data_Bpayld  : tBpayld;

   --I0
   --Read channels
   ----Read command
   signal B0_I0_ARvalid : std_logic;
   signal B0_I0_ARready : std_logic;
   signal B0_I0_ARpayld : tARpayld;
   ----Read data
   signal B0_I0_Rvalid  : std_logic;
   signal B0_I0_Rready  : std_logic;
   signal B0_I0_Rpayld  : tRpayld;
   --Write channels
   ----Write command
   signal B0_I0_AWvalid : std_logic;
   signal B0_I0_AWready : std_logic;
   signal B0_I0_AWpayld : tAWpayld;
   ----Write data
   signal B0_I0_Wvalid  : std_logic;
   signal B0_I0_Wready  : std_logic;
   signal B0_I0_Wpayld  : tWpayld;
   ----Write response
   signal B0_I0_Bvalid  : std_logic;
   signal B0_I0_Bready  : std_logic;
   signal B0_I0_Bpayld  : tBpayld;

   --D1
   --Read channels
   ----Read command
   signal B1_D1_ARvalid : std_logic;
   signal B1_D1_ARready : std_logic;
   signal B1_D1_ARpayld : tARpayld;
   ----Read data
   signal B1_D1_Rvalid  : std_logic;
   signal B1_D1_Rready  : std_logic;
   signal B1_D1_Rpayld  : tRpayld;
   --Write channels
   ----Write command
   signal B1_D1_AWvalid : std_logic;
   signal B1_D1_AWready : std_logic;
   signal B1_D1_AWpayld : tAWpayld;
   ----Write data
   signal B1_D1_Wvalid  : std_logic;
   signal B1_D1_Wready  : std_logic;
   signal B1_D1_Wpayld  : tWpayld;
   ----Write response
   signal B1_D1_Bvalid  : std_logic;
   signal B1_D1_Bready  : std_logic;
   signal B1_D1_Bpayld  : tBpayld;

   --D2
   --Read channels
   ----Read command
   signal B1_D2_ARvalid : std_logic;
   signal B1_D2_ARready : std_logic;
   signal B1_D2_ARpayld : tARpayld;
   ----Read data
   signal B1_D2_Rvalid  : std_logic;
   signal B1_D2_Rready  : std_logic;
   signal B1_D2_Rpayld  : tRpayld;
   --Write channels
   ----Write command
   signal B1_D2_AWvalid : std_logic;
   signal B1_D2_AWready : std_logic;
   signal B1_D2_AWpayld : tAWpayld;
   ----Write data
   signal B1_D2_Wvalid  : std_logic;
   signal B1_D2_Wready  : std_logic;
   signal B1_D2_Wpayld  : tWpayld;
   ----Write response
   signal B1_D2_Bvalid  : std_logic;
   signal B1_D2_Bready  : std_logic;
   signal B1_D2_Bpayld  : tBpayld;

   --D3
   --Read channels
   ----Read command
   signal B1_D3_ARvalid : std_logic;
   signal B1_D3_ARready : std_logic;
   signal B1_D3_ARpayld : tARpayld;
   ----Read data
   signal B1_D3_Rvalid  : std_logic;
   signal B1_D3_Rready  : std_logic;
   signal B1_D3_Rpayld  : tRpayld;
   --Write channels
   ----Write command
   signal B1_D3_AWvalid : std_logic;
   signal B1_D3_AWready : std_logic;
   signal B1_D3_AWpayld : tAWpayld;
   ----Write data
   signal B1_D3_Wvalid  : std_logic;
   signal B1_D3_Wready  : std_logic;
   signal B1_D3_Wpayld  : tWpayld;
   ----Write response
   signal B1_D3_Bvalid  : std_logic;
   signal B1_D3_Bready  : std_logic;
   signal B1_D3_Bpayld  : tBpayld;

   --D4
   --Read channels
   ----Read command
   signal B1_D4_ARvalid : std_logic;
   signal B1_D4_ARready : std_logic;
   signal B1_D4_ARpayld : tARpayld;
   ----Read data
   signal B1_D4_Rvalid  : std_logic;
   signal B1_D4_Rready  : std_logic;
   signal B1_D4_Rpayld  : tRpayld;
   --Write channels
   ----Write command
   signal B1_D4_AWvalid : std_logic;
   signal B1_D4_AWready : std_logic;
   signal B1_D4_AWpayld : tAWpayld;
   ----Write data
   signal B1_D4_Wvalid  : std_logic;
   signal B1_D4_Wready  : std_logic;
   signal B1_D4_Wpayld  : tWpayld;
   ----Write response
   signal B1_D4_Bvalid  : std_logic;
   signal B1_D4_Bready  : std_logic;
   signal B1_D4_Bpayld  : tBpayld;

   --D5
   --Read channels
   ----Read command
   signal B1_D5_ARvalid : std_logic;
   signal B1_D5_ARready : std_logic;
   signal B1_D5_ARpayld : tARpayld;
   ----Read data
   signal B1_D5_Rvalid  : std_logic;
   signal B1_D5_Rready  : std_logic;
   signal B1_D5_Rpayld  : tRpayld;
   --Write channels
   ----Write command
   signal B1_D5_AWvalid : std_logic;
   signal B1_D5_AWready : std_logic;
   signal B1_D5_AWpayld : tAWpayld;
   ----Write data
   signal B1_D5_Wvalid  : std_logic;
   signal B1_D5_Wready  : std_logic;
   signal B1_D5_Wpayld  : tWpayld;
   ----Write response
   signal B1_D5_Bvalid  : std_logic;
   signal B1_D5_Bready  : std_logic;
   signal B1_D5_Bpayld  : tBpayld;

begin
	I0: ROM_2pNx4s_axi
	   generic map(
		  N         => 13,
		  FILE_NAME => PROGRAM_FILE_NAME
		)
		port map(
		  --Controls
		  reset    => reset,
		  clk     => clk,
		  enable  => enable,
		  --Target
		  ------Read command
		  ARvalid  => B0_I0_ARvalid,
		  ARready  => B0_I0_ARready,
		  ARpayld  => B0_I0_ARpayld,
		  ------Read data
		  Rvalid   => B0_I0_Rvalid,
		  Rready   => B0_I0_Rready , 
		  Rpayld   => B0_I0_Rpayld ,
		  --Data Write channel
		  ----Write command
		  AWvalid  => B0_I0_AWvalid, 
		  AWready  => B0_I0_AWready,
		  AWpayld  => B0_I0_AWpayld,
		  ------Write data
		  Wvalid   => B0_I0_Wvalid,
		  Wready   => B0_I0_Wready, 
		  Wpayld   => B0_I0_Wpayld,
		  ------Write response
		  Bvalid   => B0_I0_Bvalid,
		  Bready   => B0_I0_Bready,
		  Bpayld   => B0_I0_Bpayld 
	   );
	D1 : ROM_2pNx4s_axi
	   generic map(
		  N         => 10,
		  FILE_NAME => PROGRAM_FILE_NAME
		)
		port map(
		  --Controls
		  reset    => reset,
		  clk     => clk,
		  enable  => enable,
		  --Target
		  ------Read command
		  ARvalid  => B1_D1_ARvalid,
		  ARready  => B1_D1_ARready,
		  ARpayld  => B1_D1_ARpayld,
		  ------Read data
		  Rvalid   => B1_D1_Rvalid,
		  Rready   => B1_D1_Rready , 
		  Rpayld   => B1_D1_Rpayld ,
		  --Data Write channel
		  ----Write command
		  AWvalid  => B1_D1_AWvalid, 
		  AWready  => B1_D1_AWready,
		  AWpayld  => B1_D1_AWpayld,
		  ------Write data
		  Wvalid   => B1_D1_Wvalid,
		  Wready   => B1_D1_Wready, 
		  Wpayld   => B1_D1_Wpayld,
		  ------Write response
		  Bvalid   => B1_D1_Bvalid,
		  Bready   => B1_D1_Bready,
		  Bpayld   => B1_D1_Bpayld 
	   );
	  
	D2 : RAM_2pNx4s_axi 
	   generic map(
		  N    => 10
	   )
	   port(
		  --Controls
		  reset    => reset,
		  clk      => clk,
		  enable   => enable,
		  --Target
		  ------Read command
		  ARvalid  => B1_D2_ARvalid,
		  ARready  => B1_D2_ARready,
		  ARpayld  => B1_D2_ARpayld,
		  ------Read data
		  Rvalid   => B1_D2_Rvalid,
		  Rready   => B1_D2_Rready , 
		  Rpayld   => B1_D2_Rpayld ,
		  --Data Write channel
		  ----Write command
		  AWvalid  => B1_D2_AWvalid, 
		  AWready  => B1_D2_AWready,
		  AWpayld  => B1_D2_AWpayld,
		  ------Write data
		  Wvalid   => B1_D2_Wvalid,
		  Wready   => B1_D2_Wready, 
		  Wpayld   => B1_D2_Wpayld,
		  ------Write response
		  Bvalid   => B1_D2_Bvalid,
		  Bready   => B1_D2_Bready,
		  Bpayld   => B1_D2_Bpayld 
	   );
	  D3 : uart_axi 
	   generic map(
		  SIMULATION => SIMULATION
	   )
	   port map(
		  --Controls
		  reset    => reset,
		  clk      => clk,
		  enable   => enable,
		  --Target
		  ------Read command
		  ARvalid  => B1_D3_ARvalid,
		  ARready  => B1_D3_ARready,
		  ARpayld  => B1_D3_ARpayld,
		  ------Read data
		  Rvalid   => B1_D3_Rvalid,
		  Rready   => B1_D3_Rready , 
		  Rpayld   => B1_D3_Rpayld ,
		  --Data Write channel
		  ----Write command
		  AWvalid  => B1_D3_AWvalid, 
		  AWready  => B1_D3_AWready,
		  AWpayld  => B1_D3_AWpayld,
		  ------Write data
		  Wvalid   => B1_D3_Wvalid,
		  Wready   => B1_D3_Wready, 
		  Wpayld   => B1_D3_Wpayld,
		  ------Write response
		  Bvalid   => B1_D3_Bvalid,
		  Bready   => B1_D3_Bready,
		  Bpayld   => B1_D3_Bpayld ,
		  --External interface
		  RX       => RX,
		  TX       => TX
	   );
	   D4 : gpio_axi 
	   generic map(
		  SIMULATION => SIMULATION
	   )
	   port map(
		  --Controls
		  reset    => reset,
		  clk      => clk,
		  enable   => enable,
		  --Target
		  ------Read command
		  ARvalid  => B1_D4_ARvalid,
		  ARready  => B1_D4_ARready,
		  ARpayld  => B1_D4_ARpayld,
		  ------Read data
		  Rvalid   => B1_D4_Rvalid,
		  Rready   => B1_D4_Rready , 
		  Rpayld   => B1_D4_Rpayld ,
		  --Data Write channel
		  ----Write command
		  AWvalid  => B1_D4_AWvalid, 
		  AWready  => B1_D4_AWready,
		  AWpayld  => B1_D4_AWpayld,
		  ------Write data
		  Wvalid   => B1_D4_Wvalid,
		  Wready   => B1_D4_Wready, 
		  Wpayld   => B1_D4_Wpayld,
		  ------Write response
		  Bvalid   => B1_D4_Bvalid,
		  Bready   => B1_D4_Bready,
		  Bpayld   => B1_D4_Bpayld ,
		  --External interface
		  data_in  => data_in ,
		  data_out => data_out
	   );
	   D5 : copro_axi 
	   generic map(
		  SIMULATION => SIMULATION
	   )
	   port map(
		  --Controls
		  reset    => reset,
		  clk      => clk,
		  enable   => enable,
		  --Target
		  ------Read command
		  ARvalid  => B1_D5_ARvalid,
		  ARready  => B1_D5_ARready,
		  ARpayld  => B1_D5_ARpayld,
		  ------Read data
		  Rvalid   => B1_D5_Rvalid,
		  Rready   => B1_D5_Rready , 
		  Rpayld   => B1_D5_Rpayld ,
		  --Data Write channel
		  ----Write command
		  AWvalid  => B1_D5_AWvalid, 
		  AWready  => B1_D5_AWready,
		  AWpayld  => B1_D5_AWpayld,
		  ------Write data
		  Wvalid   => B1_D5_Wvalid,
		  Wready   => B1_D5_Wready, 
		  Wpayld   => B1_D5_Wpayld,
		  ------Write response
		  Bvalid   => B1_D5_Bvalid,
		  Bready   => B1_D5_Bready,
		  Bpayld   => B1_D5_Bpayld,
		  --External interface
		  data_in  => data_in,
		  data_out => data_out
	   );
	   
	   B0 : bus_axi_1x16
		   port map(
			  --Controls
			  reset      => reset,
			  clk        => clk,
			  enable     => enable,
			  --Target
			  ----Data Read channel
			  ------Read command
			  T_ARvalid  => CPU0_inst_ARvalid,
			  T_ARready  => CPU0_inst_ARready,
			  T_ARpayld  => CPU0_inst_ARpayld,
			  ------Read data
			  T_Rvalid   => CPU0_inst_Rvalid,
			  T_Rready   => CPU0_inst_Rready,
			  T_Rpayld   => CPU0_inst_ARpayld,
			  --Data Write channel
			  ----Write command
			  T_AWvalid  => CPU0_inst_AWvalid,
			  T_AWready  => CPU0_inst_AWready,
			  T_AWpayld  => CPU0_inst_AWpayld,
			  ------Write data
			  T_Wvalid   => CPU0_inst_Wvalid,
			  T_Wready   => CPU0_inst_Wready,
			  T_Wpayld   => CPU0_inst_Wpayld,
			  ------Write response
			  T_Bvalid   => CPU0_inst_Bvalid,
			  T_Bready   => CPU0_inst_Bready,
			  T_Bpayld   => CPU0_inst_Bpayld,
			  --Initiators
			  ----Data Read channel
			  ------Read command
			  I0_ARvalid => B0_I0_ARvalid,
			  I0_ARready => B0_I0_ARready,
			  I0_ARpayld => B0_I0_ARpayld,
			  I0_Rvalid => 	B0_I0_Rvalid,
			  I0_Rready => 	B0_I0_Rready,
			  I0_Rpayld => 	B0_I0_Rpayld,
			  I0_AWvalid => B0_I0_AWvalid,
			  I0_AWready => B0_I0_AWready,
			  I0_AWpayld => B0_I0_AWpayld,
			  I0_Wvalid => 	B0_I0_Wvalid,
			  I0_Wready => 	B0_I0_Wready,
			  I0_Wpayld => 	B0_I0_Wpayld,
			  I0_Bvalid => 	B0_I0_Bvalid,
			  I0_Bready =>	B0_I0_Bready,
			  I0_Bpayld => 	B0_I0_Bpayld
			  
		   );
	
		   B1 : bus_axi_1x16
		   port map(
			  --Controls
			  reset      => reset,
			  clk        => clk,
			  enable     => enable,
			  --Target
			  ----Data Read channel
			  ------Read command
			  T_ARvalid  => CPU0_data_ARvalid,
			  T_ARready  => CPU0_data_ARready,
			  T_ARpayld  => CPU0_data_ARpayld,
			  ------Read data
			  T_Rvalid   => CPU0_data_Rvalid,
			  T_Rready   => CPU0_data_Rready,
			  T_Rpayld   => CPU0_data_ARpayld,
			  --Data Write channel
			  ----Write command
			  T_AWvalid  => CPU0_data_AWvalid,
			  T_AWready  => CPU0_data_AWready,
			  T_AWpayld  => CPU0_data_AWpayld,
			  ------Write data
			  T_Wvalid   => CPU0_data_Wvalid,
			  T_Wready   => CPU0_data_Wready,
			  T_Wpayld   => CPU0_data_Wpayld,
			  ------Write response
			  T_Bvalid   => CPU0_data_Bvalid,
			  T_Bready   => CPU0_data_Bready,
			  T_Bpayld   => CPU0_data_Bpayld,
																																				
				I1_ARvalid 	 => B1_D1_ARvalid, I2_ARvalid 	=> B1_D2_ARvalid,  I3_ARvalid 	=> B1_D3_ARvalid,  I4_ARvalid 	=> B1_D4_ARvalid,    I5_ARvalid   => B1_D5_ARvalid,
				I1_ARready   => B1_D1_ARready, I2_ARready   => B1_D2_ARready,  I3_ARready   => B1_D3_ARready,  I4_ARready   => B1_D4_ARready,    I5_ARready   => B1_D5_ARready,
				I1_ARpayld   => B1_D1_ARpayld, I2_ARpayld   => B1_D2_ARpayld,  I3_ARpayld   => B1_D3_ARpayld,  I4_ARpayld   => B1_D4_ARpayld,    I5_ARpayld   => B1_D5_ARpayld,
				I1_Rvalid    => B1_D1_Rvalid,  I2_Rvalid    => B1_D2_Rvalid,   I3_Rvalid    => B1_D3_Rvalid,   I4_Rvalid    => B1_D4_Rvalid,     I5_Rvalid    => B1_D5_Rvalid,
				I1_Rready    => B1_D1_Rready,  I2_Rready    => B1_D2_Rready,   I3_Rready    => B1_D3_Rready,   I4_Rready    => B1_D4_Rready,     I5_Rready    => B1_D5_Rready,
				I1_Rpayld    => B1_D1_Rpayld,  I2_Rpayld    => B1_D2_Rpayld,   I3_Rpayld    => B1_D3_Rpayld,   I4_Rpayld    => B1_D4_Rpayld,     I5_Rpayld    => B1_D5_Rpayld,
				I1_AWvalid   => B1_D1_AWvalid, I2_AWvalid   => B1_D2_AWvalid,  I3_AWvalid   => B1_D3_AWvalid,  I4_AWvalid   => B1_D4_AWvalid,    I5_AWvalid   => B1_D5_AWvalid,
				I1_AWready   => B1_D1_AWready, I2_AWready   => B1_D2_AWready,  I3_AWready   => B1_D3_AWready,  I4_AWready   => B1_D4_AWready,    I5_AWready   => B1_D5_AWready,
				I1_AWpayld   => B1_D1_AWpayld, I2_AWpayld   => B1_D2_AWpayld,  I3_AWpayld   => B1_D3_AWpayld,  I4_AWpayld   => B1_D4_AWpayld,    I5_AWpayld   => B1_D5_AWpayld,
				I1_Wvalid    => B1_D1_Wvalid,  I2_Wvalid    => B1_D2_Wvalid,   I3_Wvalid    => B1_D3_Wvalid,   I4_Wvalid    => B1_D4_Wvalid,     I5_Wvalid    => B1_D5_Wvalid,
				I1_Wready    => B1_D1_Wready,  I2_Wready    => B1_D2_Wready,   I3_Wready    => B1_D3_Wready,   I4_Wready    => B1_D4_Wready,     I5_Wready    => B1_D5_Wready,
				I1_Wpayld    => B1_D1_Wpayld,  I2_Wpayld    => B1_D2_Wpayld,   I3_Wpayld    => B1_D3_Wpayld,   I4_Wpayld    => B1_D4_Wpayld,     I5_Wpayld    => B1_D5_Wpayld,
				I1_Bvalid    => B1_D1_Bvalid,  I2_Bvalid    => B1_D2_Bvalid,   I3_Bvalid    => B1_D3_Bvalid,   I4_Bvalid    => B1_D4_Bvalid,     I5_Bvalid    => B1_D5_Bvalid,
				I1_Bready    => B1_D1_Bready,  I2_Bready    => B1_D2_Bready,   I3_Bready    => B1_D3_Bready,   I4_Bready    => B1_D4_Bready,     I5_Bready    => B1_D5_Bready,
				I1_Bpayld    => B1_D1_Bpayld , I2_Bpayld    => B1_D2_Bpayld ,  I3_Bpayld    => B1_D3_Bpayld ,  I4_Bpayld    => B1_D4_Bpayld ,    I5_Bpayld    => B1_D5_Bpayld 
	);	                                                         
end a;