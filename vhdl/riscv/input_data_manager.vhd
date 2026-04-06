library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;

entity input_data_manager is
	port(
      inst     : in  std_logic_vector(32-1 downto 0);
      BE       : in  std_logic_vector( 4-1 downto 0);
      data_in  : in  std_logic_vector(32-1 downto 0);
      data_out : out std_logic_vector(32-1 downto 0)
	);
end entity;

architecture a of input_data_manager is

   signal funct3   : std_logic_vector(3-1 downto 0);

begin

   funct3 <= inst(14 downto 12);

  process(funct3,BE,data_in)
   begin
      case funct3 is
	  	when "010" => data_out <= data_in(31 downto 0); -- LW
		when "001" =>  --LH
			case BE is 
				when "0011" => data_out <= x"FFFF" &  data_in(15 downto 0)  ;
				when "1100" => data_out <= x"FFFF" &  data_in(31 downto 16) ;
				when others=> data_out <= (others=>'-'); 
			end case;
		when "101" =>  --LHU
			case BE is 
				when "0011" => data_out <= x"0000" & data_in(15 downto 0)  ;
				when "1100" => data_out <= x"0000" & data_in(31 downto 16);
				when others=> data_out <= (others=>'-'); 
			end case;
		when "100" =>  --LBU
			case BE is 
				when "0001" => data_out <= x"000000" & data_in(7 downto 0);
				when "0010" => data_out <= x"000000" & data_in(15 downto 8);
				when "0100" => data_out <= x"000000" & data_in(23 downto 16);
				when "1000" => data_out <= x"000000" & data_in(31 downto 24);	
				when others=> data_out <= (others=>'-'); 
			end case;
		when "000" =>  --LB
			case BE is 
				when "0001" => data_out <= x"FFFFFF" & data_in(7 downto 0);
				when "0010" => data_out <= x"FFFFFF" & data_in(15 downto 8);
				when "0100" => data_out <= x"FFFFFF" & data_in(23 downto 16);
				when "1000" => data_out <= x"FFFFFF" & data_in(31 downto 24);
				when others=> data_out <= (others=>'-'); 
			end case;	

		 when others=> data_out <= (others=>'-'); 
      end case;
   end process;

end a;