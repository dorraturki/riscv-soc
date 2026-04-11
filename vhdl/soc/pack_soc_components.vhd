library ieee;
use ieee.std_logic_1164.all;

package pack_soc_components is

   component ibus
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
   end component;

   component dbus
      port(
         --Master
         Master_DBE        : in  std_logic_vector( 4-1 downto 0);
         Master_DAddr      : in  std_logic_vector(32-1 downto 2); 
         Master_DRead      : in  std_logic;
         Master_DWrite     : in  std_logic;
         Master_DData_wr   : in  std_logic_vector(32-1 downto 0);
         Master_DData_rd   : out std_logic_vector(32-1 downto 0);
         --Slave 0
         slave0_DBE        : out std_logic_vector( 4-1 downto 0);
         slave0_DAddr      : out std_logic_vector(32-1 downto 2); 
         slave0_DRead      : out std_logic;
         slave0_DWrite     : out std_logic;
         slave0_DData_wr   : out std_logic_vector(32-1 downto 0);
         slave0_DData_rd   : in  std_logic_vector(32-1 downto 0);
         --Slave 1
         slave1_DBE        : out std_logic_vector( 4-1 downto 0);
         slave1_DAddr      : out std_logic_vector(32-1 downto 2); 
         slave1_DRead      : out std_logic;
         slave1_DWrite     : out std_logic;
         slave1_DData_wr   : out std_logic_vector(32-1 downto 0);
         slave1_DData_rd   : in  std_logic_vector(32-1 downto 0);
         --Others
         bus_error         : out std_logic
      );
   end component;

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

   component soc1
      generic(
         PC_START_ADDRESS    : std_logic_vector(32-1 downto 0) := x"0000_0000";
         TRACE               : boolean                         := false;
         PROGRAM_FILE_NAME   : string                          := "I0.mem";
         CONSTANTS_FILE_NAME : string                          := "D0.mem"
      );
      port(
         reset : in std_logic;
         clk   : in std_logic
      );
   end component;

end package;