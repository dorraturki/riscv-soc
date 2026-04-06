library ieee;
use ieee.std_logic_1164.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;
use RISCV.pack_RISCV32I_components.all;

library RISCV_reference;

entity tb_BE_generator is
end entity;

architecture a of tb_BE_generator is

   for DUT           : BE_generator use entity riscv.BE_generator(a);
   for DUT_reference : BE_generator use entity riscv_reference.BE_generator(a);

   signal inst         : std_logic_vector(32-1 downto 0);
   signal address      : std_logic_vector( 2-1 downto 0);
   signal BE           : std_logic_vector( 4-1 downto 0);
   signal BE_reference : std_logic_vector( 4-1 downto 0);
   signal OK           : boolean;

begin

   DUT : BE_generator
   port map(
      inst    => inst,
      address => address,
      BE      => BE     
   );
   
   process
   begin
      -- Load
         -- LW
         inst <= x"00002e03"; address<="00"; wait for 100 ns; --lw t3,0(zero)      
         -- Signed
            -- LH
            inst <= x"00001e03"; address<="00"; wait for 100 ns; -- lh t3,0(zero)
            inst <= x"00201e03"; address<="10"; wait for 100 ns; -- lh t3,2(zero)
            -- LB
            inst <= x"00000e03"; address<="00"; wait for 100 ns; -- lb t3,0(zero)
            inst <= x"00100e03"; address<="01"; wait for 100 ns; -- lb t3,1(zero)
            inst <= x"00200e03"; address<="10"; wait for 100 ns; -- lb t3,2(zero)
            inst <= x"00300e03"; address<="11"; wait for 100 ns; -- lb t3,3(zero)
         -- Unsigned
            -- LHU
            inst <= x"00005e03"; address<="00"; wait for 100 ns; -- lhu t3,0(zero)
            inst <= x"00205e03"; address<="10"; wait for 100 ns; -- lhu t3,2(zero)
            -- LBU
            inst <= x"00004e03"; address<="00"; wait for 100 ns; -- lbu t3,0(zero)
            inst <= x"00104e03"; address<="01"; wait for 100 ns; -- lbu t3,1(zero)
            inst <= x"00204e03"; address<="10"; wait for 100 ns; -- lbu t3,2(zero)
            inst <= x"00304e03"; address<="11"; wait for 100 ns; -- lbu t3,3(zero)
      
      -- Store
         -- SW
         inst <= x"01c02023"; address<="00"; wait for 100 ns; -- sw t3,0(zero)
         --SH
         inst <= x"01c01023"; address<="00"; wait for 100 ns; -- sh t3,0(zero)
         inst <= x"01c01123"; address<="10"; wait for 100 ns; -- sh t3,2(zero)
         --SB
         inst <= x"01c00023"; address<="00"; wait for 100 ns; -- sb t3,0(zero)
         inst <= x"01c000a3"; address<="01"; wait for 100 ns; -- sb t3,1(zero)
         inst <= x"01c00123"; address<="10"; wait for 100 ns; -- sb t3,2(zero)
         inst <= x"01c001a3"; address<="11"; wait for 100 ns; -- sb t3,3(zero)
      wait;
   end process;

	DUT_reference : BE_generator
	port map(
		inst    => inst,
		address => address,
		BE      => BE_reference     
	);
	
	OK <= true when BE = BE_reference else false;   
 
end a;