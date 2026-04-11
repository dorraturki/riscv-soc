library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV;
use RISCV.pack_RISCV32I_components.all;

library soc;
use soc.pack_soc_components.all;

entity tb_soc1 is
   generic(
      PC_START_ADDRESS    : std_logic_vector(32-1 downto 0) := x"0000_0000";
      TRACE               : boolean                         := true;
      PROGRAM_FILE_NAME   : string                          := "I0.mem";
      CONSTANTS_FILE_NAME : string                          := "D0.mem"
   );
end entity;

architecture a of tb_soc1 is

   signal reset : std_logic;
   signal clk   : std_logic := '1';

begin

   DUT : soc1
   generic map(
      PC_START_ADDRESS   => PC_START_ADDRESS,
      TRACE              => TRACE,
      PROGRAM_FILE_NAME  => PROGRAM_FILE_NAME,
      CONSTANTS_FILE_NAME => CONSTANTS_FILE_NAME
  )
     port map(
      reset => reset,
      clk   => clk
   );
   
    reset <= '1', '0' after 160 ns;
	clk <= not clk after 50 ns;
   
end a;
