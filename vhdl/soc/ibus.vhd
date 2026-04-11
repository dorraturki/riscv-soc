library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ibus is
   port(
      --Master interface
      Master_IAddr : in  std_logic_vector(32-1 downto 2); 
      Master_IData : out std_logic_vector(32-1 downto 0);
      --Slave interface
      Slave_IAddr  : out std_logic_vector(32-1 downto 2); 
      Slave_IData  : in  std_logic_vector(32-1 downto 0);
      --Others
      bus_error    : out std_logic
   );
end entity;

architecture a of ibus is
begin

   process(Master_IAddr,Slave_IData)
   begin
      if (Master_IAddr(31)='0')
         then --Program space
              Slave_IAddr  <= Master_IAddr;
              Master_IData <= Slave_IData;
              bus_error    <= '0';
         else --Data space
              Slave_IAddr  <= (others=>'-');
              Master_IData <= (others=>'-');
              bus_error    <= '1';
      end if;
   end process;

end a;
