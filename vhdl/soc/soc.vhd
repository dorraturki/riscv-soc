library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV;
use RISCV.pack_RISCV32I_components.all;

library soc;
use soc.pack_soc_components.all;

entity soc is
   generic(
      PC_START_ADDRESS    : std_logic_vector(32-1 downto 0) := x"0000_0000";
      TRACE               : boolean                         := false;
      PROGRAM_FILE_NAME   : string                          := "I0.mem";
      CONSTANTS_FILE_NAME : string                          := "D0.mem"
   );
   port(
      reset : in std_logic;
      clk   : in std_logic
   );
end entity;

architecture a of soc is

   --System
   signal B0_bus_error    : std_logic; 
   signal B1_bus_error    : std_logic; 

   --CPU
   ----Instructions Bus 
   signal CPU_IAddr       : std_logic_vector(32-1 downto 2); 
   signal CPU_IData       : std_logic_vector(32-1 downto 0); 
   ----Data Bus
   signal CPU_DBE         : std_logic_vector( 4-1 downto 0);
   signal CPU_DAddr       : std_logic_vector(32-1 downto 2); 
   signal CPU_DRead       : std_logic;
   signal CPU_DWrite      : std_logic;
   signal CPU_DData_out   : std_logic_vector(32-1 downto 0);
   signal CPU_DData_in    : std_logic_vector(32-1 downto 0);

   --I0
   signal I0_IAddr        : std_logic_vector(32-1 downto 2); 
   signal I0_IData        : std_logic_vector(32-1 downto 0); 

   --D0
   signal D0_DAddr        : std_logic_vector(32-1 downto 2); 
   signal D0_DData_rd     : std_logic_vector(32-1 downto 0);
   
   --D1
   signal D1_DBE          : std_logic_vector( 4-1 downto 0);
   signal D1_DAddr        : std_logic_vector(32-1 downto 2); 
   signal D1_DRead        : std_logic;
   signal D1_DWrite       : std_logic;
   signal D1_DData_wr     : std_logic_vector(32-1 downto 0);
   signal D1_DData_rd     : std_logic_vector(32-1 downto 0);

begin

    --ROM32
   I0 : ROM_2pNx4
    generic map(
      N         => 13,
      FILE_NAME => PROGRAM_FILE_NAME
	)
	port map(
      address => I0_IAddr,
      data    => I0_IData 
	);
   
	--ROM4
    D0 : ROM_2pNx4
    generic map(
      N         => 4,
      FILE_NAME => CONSTANTS_FILE_NAME
	)
	port map(
      address => D0_DAddr,
      data    => D0_DData_rd 
	);
	
	--RAM
	D1 : RAM_2pNx4
    generic map(
      N         => 4
	)
	
	port map(
      clk      => clk,
      RnW      => D1_DRead,
      address  => D1_DAddr,
      BE       => D1_DBE,
      data_in  => D1_DData_wr,
      data_out => D1_DData_rd  
	);
	
	--CPU 
	CPU : RISCV32I_core
	generic map(
      PC_START_ADDRESS => PC_START_ADDRESS
	)
	port map(
      --Controls
      reset       => reset,
      clk         => clk,
      enable_PC   => '1',
      enable_RB   => '1',
      --Instructions Bus 
      IAddr       => CPU_IAddr, 
      IData       => CPU_IData,
      --Data Bus
      DBE         => CPU_DBE,
      DAddr       => CPU_DAddr,
      DRead       => CPU_DRead,
      DWrite      => CPU_DWrite,
      DData_out   => CPU_DData_out,
      DData_in    => CPU_DData_in
   );
   
   --Instruction Bus
   B0 : ibus
   port map(
      --Master interface
      Master_IAddr => CPU_IAddr,
      Master_IData => CPU_IData,
      --Slave interface
      Slave_IAddr  => I0_IAddr ,
      Slave_IData  => I0_IData,
      --Others
      bus_error    => B0_bus_error
   );   
   
   -- Data Bus
    B1 :  dbus
	port map(
      --Master
      Master_DBE   => CPU_DBE,
      Master_DAddr => CPU_DAddr,
      Master_DRead => CPU_DRead,
      Master_DWrite   => CPU_DWrite,
      Master_DData_wr  => CPU_DData_out,
      Master_DData_rd  => CPU_DData_in,
      --Slave 0
      slave0_DBE      => open,
      slave0_DAddr    => D0_DAddr,
      slave0_DRead    => open,
      slave0_DWrite   => open,
      slave0_DData_wr => open,
      slave0_DData_rd => D0_DData_rd, 
      --Slave 1
		slave1_DBE      => D1_DBE,
		slave1_DAddr     => D1_DAddr,
	   slave1_DRead     => D1_DRead,
	   slave1_DWrite    => D1_DWrite,
	   slave1_DData_wr  => D1_DData_wr,     
	   slave1_DData_rd  => D1_DData_rd,       
      --Others
      bus_error           => B1_bus_error
   );
end a;
