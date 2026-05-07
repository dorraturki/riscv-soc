library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity ROM_2pNx4s is
   generic(
      N         : integer;
      FILE_NAME : string :="none"
   );
   port(
       reset   : in  std_logic;
       clk     : in  std_logic;
       address : in  std_logic_vector(32-1 downto 2);
       data    : out std_logic_vector(32-1 downto 0)
   );
end entity;

architecture a of ROM_2pNx4s is
    
   type ttab is array (0 to 2**N-1) of std_logic_vector(32-1 downto 0);


   impure function InitMemFromFile (MemFileName : in string) return ttab is
      file text_file : text open read_mode is MemFileName;
      variable text_line : line;
      variable mem_content : ttab;
   begin
      readline(text_file, text_line);           --Skip the first line
      for i in ttab'range loop                  --Load data from file to memory, line by line
         if(not endfile(text_file))then
             readline(text_file, text_line);
             hread(text_line, mem_content(i));
         end if;
      end loop;
     return mem_content;
   end function;
   
   signal tab : ttab := InitMemFromFile(FILE_NAME);

begin   
    
   process(clk)
   begin
      if (clk'event and clk='1') 
         then if (reset='1')
                 then data <= (others=>'0');
                 else data <= tab(to_integer(unsigned(address(N+2-1 downto 2))));
              end if;
      end if;
   end process;
   
end a;
