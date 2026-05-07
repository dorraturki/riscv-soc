library ieee;
use ieee.std_logic_1164.all;

library soc;
use soc.pack_axi_types.all;

package pack_memory_components is

   component ROM_2pNx4
      generic(
         N         : integer;
         FILE_NAME : string
      );
      port(
         address : in  std_logic_vector(32-1 downto 2);
         data    : out std_logic_vector(32-1 downto 0)
      );
   end component;

   component ROM_2pNx4s
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
   end component;

   component ROM_2pNx4s_axi
      generic(
         N         : integer;
         FILE_NAME : string :="none"
      );
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
         Bpayld   : out tBpayld
      );
   end component;

   component RAM_2pNx4
      generic(
         N         : integer
      );
      port(
         clk      : in  std_logic;
         RnW      : in  std_logic;
         address  : in  std_logic_vector(32-1 downto 2);
         BE       : in  std_logic_vector( 4-1 downto 0);
         data_in  : in  std_logic_vector(32-1 downto 0);
         data_out : out std_logic_vector(32-1 downto 0)
      );
   end component;

   component RAM_2pNx4s
      generic(
         N       : integer
      );
      port(
         reset    : in  std_logic;
         clk      : in  std_logic;
         RnW      : in  std_logic;
         address  : in  std_logic_vector(32-1 downto 2);
         BE       : in  std_logic_vector( 4-1 downto 0);
         data_in  : in  std_logic_vector(32-1 downto 0);
         data_out : out std_logic_vector(32-1 downto 0)
      );
   end component;

   component RAM_2pNx4s_axi
      generic(
         N         : integer
      );
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
         Bpayld   : out tBpayld
      );
   end component;

end package;