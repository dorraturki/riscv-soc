library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
   port(
      inst : in  std_logic_vector(32-1 downto 0);
      rs1a : out std_logic_vector( 5-1 downto 0);
      rs2a : out std_logic_vector( 5-1 downto 0);
      rda  : out std_logic_vector( 5-1 downto 0);
      immI : out std_logic_vector(32-1 downto 0);
      immS : out std_logic_vector(32-1 downto 0);
      immB : out std_logic_vector(32-1 downto 0);
      immU : out std_logic_vector(32-1 downto 0);
      immJ : out std_logic_vector(32-1 downto 0)
   );
end entity;

architecture a of decoder is
   
begin

   
   rs1a <= inst(19 downto 15);
   
   rs2a <= inst(24 downto 20);
   
   rda  <= inst(11 downto 7);

   immI <= std_logic_vector(resize(signed(inst(31 downto 20)),32));
      
   immS <= std_logic_vector(resize(signed(inst(31 downto 25) & inst(11 downto 7)),32));
   
   immB <= std_logic_vector(resize(signed(inst(31) & inst(7) & inst(30 downto 25) & inst(11 downto 8) & '0'),32));
   
   immU <= std_logic_vector(resize(signed(inst(31 downto 12) & x"000"),32));
   
   immJ <= std_logic_vector(resize(signed(inst(31) & inst(19 downto 12) & inst(20) & inst(30 downto 21) & '0'),32));

end a;