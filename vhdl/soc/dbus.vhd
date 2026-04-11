library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dbus is
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
end entity;

architecture a of dbus is
begin

   process(Master_DBE,Master_DAddr,Master_DRead,Master_DWrite,Master_DData_wr,slave0_DData_rd,slave1_DData_rd)
   begin
      --Master defaults
      Master_DData_rd  <= (others=>'-');
      --Slave 0 defaults
      slave0_DBE       <= (others=>'-');
      slave0_DAddr     <= (others=>'-');
      slave0_DRead     <= '0';
      slave0_DWrite    <= '0';
      slave0_DData_wr  <= (others=>'-');
      --Slave 1 defaults
      slave1_DBE       <= (others=>'-');
      slave1_DAddr     <= (others=>'-');
      slave1_DRead     <= '0';
      slave1_DWrite    <= '0';
      slave1_DData_wr  <= (others=>'-');
      
      if (Master_DAddr(31)='1')
         then --Data space
              bus_error    <= '0';
              if (Master_DAddr(30)='0')
                  then --Slave 0 selected
                       --Master
                       Master_DData_rd  <= slave0_DData_rd;
                       --Slave 0
                       slave0_DBE       <= Master_DBE;
                       slave0_DAddr     <= Master_DAddr; 
                       slave0_DRead     <= Master_DRead;
                       slave0_DWrite    <= Master_DWrite;
                       slave0_DData_wr  <= Master_DData_wr;
                  else --Slave 1 selected
                       --Master
                       Master_DData_rd  <= slave1_DData_rd;
                       --Slave 1
                       slave1_DBE       <= Master_DBE;
                       slave1_DAddr     <= Master_DAddr; 
                       slave1_DRead     <= Master_DRead;
                       slave1_DWrite    <= Master_DWrite;
                       slave1_DData_wr  <= Master_DData_wr;
              end if;
         else --Program space
              bus_error    <= '1';
      end if;
   end process;

end a;
