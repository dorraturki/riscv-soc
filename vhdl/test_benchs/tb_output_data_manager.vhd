library ieee;
use ieee.std_logic_1164.all;

library RISCV;
use RISCV.pack_RISCV32I_components.all;
use RISCV.pack_RISCV32I_types.all;

library RISCV_reference;

entity tb_output_data_manager is
end entity;

architecture a of tb_output_data_manager is

   for DUT           : output_data_manager use entity riscv.output_data_manager(a);
   for DUT_reference : output_data_manager use entity riscv_reference.output_data_manager(a);

   signal inst_str           : string(1 to 15);
   signal inst               : std_logic_vector(32-1 downto 0);
   signal data_in            : std_logic_vector(32-1 downto 0);
   signal data_out           : std_logic_vector(32-1 downto 0);
   signal data_out_reference : std_logic_vector(32-1 downto 0);
   signal OK                 : boolean;

begin

   DUT : output_data_manager
   port map(
      inst     => inst,
      data_in  => data_in,
      data_out => data_out
   );

   data_in <= x"DDCCBBAA";

   process
   begin
      --SW
      inst_str <= "sw t3,0(zero)  "; inst <= x"01c02023"; wait for 100 ns; 
	  
	  --SH
      inst_str <= "sh t3,0(zero)  "; inst <= x"01c01023"; wait for 100 ns;
      inst_str <= "sh t3,2(zero)  "; inst <= x"01c01123"; wait for 100 ns;
      --SB
      inst_str <= "sb t3,0(zero)  "; inst <= x"01c00023"; wait for 100 ns;
      inst_str <= "sb t3,1(zero)  "; inst <= x"01c000a3"; wait for 100 ns;
      inst_str <= "sb t3,2(zero)  "; inst <= x"01c00123"; wait for 100 ns;
      inst_str <= "sb t3,3(zero)  "; inst <= x"01c001a3"; wait for 100 ns;
      wait;
   end process;

	DUT_reference : output_data_manager
	port map(
		inst     => inst,
		data_in  => data_in,
		data_out => data_out_reference
	);
	
	OK <= true when data_out = data_out_reference else false;

end a;