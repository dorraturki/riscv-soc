library ieee;
use ieee.std_logic_1164.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;

entity output_data_manager is
   port(
      inst     : in  std_logic_vector(32-1 downto 0);
      data_in  : in  std_logic_vector(32-1 downto 0);
      data_out : out std_logic_vector(32-1 downto 0)
   );
end entity;

architecture a of output_data_manager is

   signal funct3   : std_logic_vector(3-1 downto 0);

begin

   funct3 <= inst(14 downto 12);

   process(funct3,data_in)
   begin
      case funct3 is
		  when "000" => data_out <= data_in( 7 downto 0) & data_in( 7 downto 0) & data_in(7 downto 0) & data_in(7 downto 0);
		  when "001" => data_out <= data_in(15 downto 0) & data_in(15 downto 0);
		  when "010" => data_out <= data_in(31 downto 0);
		  when others=> data_out <= (others=>'-'); 
      end case;
   end process;

end a;