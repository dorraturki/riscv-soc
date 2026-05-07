library ieee;
use ieee.std_logic_1164.all;

library soc;
use soc.pack_axi_types.all;

package pack_copro_components is

   component copro_axi
      port(
         --Controls
         reset    : in  std_logic;
         clk      : in  std_logic; 
         enable   : in  std_logic;
         --Target
         ------Read command
         ARvalid  : in  std_logic; 
         ARready  : out std_logic; 
         ARpayld  : in  tARpayld;
         ------Read data
         Rvalid   : out std_logic; 
         Rready   : in  std_logic; 
         Rpayld   : out tRpayld;
         --Data Write channel
         ----Write command
         AWvalid  : in  std_logic; 
         AWready  : out std_logic; 
         AWpayld  : in  tAWpayld;
         ------Write data
         Wvalid   : in  std_logic; 
         Wready   : out std_logic; 
         Wpayld   : in  tWpayld;
         ------Write response
         Bvalid   : out std_logic; 
         Bready   : in  std_logic; 
         Bpayld   : out tBpayld;
         --External interface
         video_in  : in  std_logic_vector(32-1 downto 0);
         video_out : out std_logic_vector(32-1 downto 0)
      );
   end component;

end package;