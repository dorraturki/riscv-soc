library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegBank is
   port(
      --Contrôles
      reset        : in  std_logic;
      clk          : in  std_logic;
      enable       : in  std_logic;
      --Port d'écriture
      wr           : in  std_logic;
      address_in   : in  std_logic_vector( 5-1 downto 0);
      data_in      : in  std_logic_vector(32-1 downto 0);
      --Ports de lecture 1
      address_out1 : in  std_logic_vector( 5-1 downto 0);
      data_out1    : out std_logic_vector(32-1 downto 0);
      --Ports de lecture 2
      address_out2 : in  std_logic_vector( 5-1 downto 0);
      data_out2    : out std_logic_vector(32-1 downto 0)
   );
end entity;

architecture a of RegBank is

   type ttab is array (0 to 31) of std_logic_vector(31 downto 0);

   signal tab : ttab;

begin  

   process(reset,clk)
   begin
      if (reset='1')
         then for i in 0 to 31 loop
                  tab(i) <= (others=>'0');
              end loop;
         else if rising_edge(clk)
                 then if (enable='1' and wr='1' and to_integer(unsigned(address_in))/=0)
                         then tab(to_integer(unsigned(address_in)))<=data_in;
                      end if;
              end if;
      end if;
   end process;

   data_out1 <= (others=>'0') when (to_integer(unsigned(address_out1))=0) else tab(to_integer(unsigned(address_out1)));
   
   data_out2 <= (others=>'0') when (to_integer(unsigned(address_out2))=0) else tab(to_integer(unsigned(address_out2)));

end a;
