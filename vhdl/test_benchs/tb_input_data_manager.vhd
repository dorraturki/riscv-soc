library ieee;
use ieee.std_logic_1164.all;

library RISCV;
use RISCV.pack_RISCV32I_components.all;
use RISCV.pack_RISCV32I_types.all;

library RISCV_reference;

entity tb_input_data_manager is
end entity;

architecture a of tb_input_data_manager is

   for DUT           : input_data_manager use entity riscv.input_data_manager(a);
   for DUT_reference : input_data_manager use entity riscv_reference.input_data_manager(a);

   signal inst_str           : string(1 to 15);
   signal inst               : std_logic_vector(32-1 downto 0);
   signal BE                 : std_logic_vector( 4-1 downto 0);
   signal data_in            : std_logic_vector(32-1 downto 0);
   signal data_out           : std_logic_vector(32-1 downto 0);
   signal data_out_reference : std_logic_vector(32-1 downto 0);
   signal OK                 : boolean;

begin

   DUT : input_data_manager
   port map(
      inst     => inst,
      BE       => BE,
      data_in  => data_in,
      data_out => data_out
   );

   data_in <= x"CCDDEEFF";

   process
   begin
      --LW
      inst_str <= "lw t3,0(zero)  "; inst <= x"00002e03"; BE <= "1111" ; wait for 100 ns;
      --LH
      inst_str <= "lh t3,0(zero)  "; inst <= x"00001e03"; BE <= "0011" ; wait for 100 ns;
      inst_str <= "lh t3,2(zero)  "; inst <= x"00201e03"; BE <= "1100" ; wait for 100 ns;
      --LHU
      inst_str <= "lhu t3,0(zero) "; inst <= x"00005e03"; BE <= "0011" ; wait for 100 ns;
      inst_str <= "lhu t3,2(zero) "; inst <= x"00205e03"; BE <= "1100" ; wait for 100 ns;
      --LB
      inst_str <= "lb t3,0(zero)  "; inst <= x"00000e03"; BE <= "0001" ; wait for 100 ns;
      inst_str <= "lb t3,1(zero)  "; inst <= x"00100e03"; BE <= "0010" ; wait for 100 ns;
      inst_str <= "lb t3,2(zero)  "; inst <= x"00200e03"; BE <= "0100" ; wait for 100 ns;
      inst_str <= "lb t3,3(zero)  "; inst <= x"00300e03"; BE <= "1000" ; wait for 100 ns;
      --LBU
      inst_str <= "lbu t3,0(zero) "; inst <= x"00004e03"; BE <= "0001" ; wait for 100 ns;
      inst_str <= "lbu t3,1(zero) "; inst <= x"00104e03"; BE <= "0010" ; wait for 100 ns;
      inst_str <= "lbu t3,2(zero) "; inst <= x"00204e03"; BE <= "0100" ; wait for 100 ns;
      inst_str <= "lbu t3,3(zero) "; inst <= x"00304e03"; BE <= "1000" ; wait for 100 ns;
      wait;
   end process;

	DUT_reference : input_data_manager
	port map(
		inst     => inst,
		BE       => BE,
		data_in  => data_in,
		data_out => data_out_reference
	);
	
	OK <= true when data_out = data_out_reference else false;

end a;