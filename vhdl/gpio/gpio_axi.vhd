library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library soc;
use soc.pack_axi_types.all;

library gpio;
use gpio.pack_gpio_components.all;

entity gpio_axi is
   generic(
      SIMULATION : boolean := false
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
      Bpayld   : out tBpayld;
      --External interface
      data_in  : in  std_logic_vector(32-1 downto 0);
      data_out : out std_logic_vector(32-1 downto 0)
   );
end entity;

architecture a of gpio_axi is

   type stateR is (S0,S1,S2);

   signal pstateR : stateR;
   signal fstateR : stateR;

   type stateW is (S0,S1,S2,S3);

   signal pstateW : stateW;
   signal fstateW : stateW;

begin


--Réception
   --FSM lecture
   process(clk)
   begin
      if rising_edge(clk)
         then    if (reset  ='1') then pstateR <= S0     ;
              elsif (enable ='1') then pstateR <= fstateR;
                                  else pstateR <= pstateR;
              end if;
      end if;
   end process;
   
   process(pstateR,ARvalid,Rready)
   begin
      ARready <= '0';
      Rvalid  <= '0';
      
      
      case pstateR is

         when S0 => 
                    fstateR <= S1;

         when S1 => 
                    ARready <= '1';
                    if (ARvalid='1')
                       then 
                            fstateR <= S2;
                       else 
                            fstateR <= S1;
                    end if;  

         when S2 => 
                    Rvalid <= '1';
                    if (Rready='1')
                       then 
                            fstateR <= S1;
                       else 
                            fstateR <= S2;
                    end if;  

      end case;
   end process;
   
   --à compléter

   --FSM writing
   process(clk)
   begin
      if rising_edge(clk)
         then    if (reset  ='1') then pstateW <= S0     ;
              elsif (enable ='1') then pstateW <= fstateW;
                                  else pstateW <= pstateW;
              end if;
      end if;
   end process;

   process(pstateW,AWvalid,Wvalid,Bready)
   begin
      AWready     <= '0';
      Wready      <= '0';
      Bvalid      <= '0';
      
      case pstateW is

         when S0 => 
                    fstateW <= S1;

         when S1 =>
                    AWready <= '1';
                    if (AWvalid='1')
                       then 
                            fstateW <= S2;
                       else 
                            fstateW <= S1;
                    end if;  

         when S2 => 
                    Wready <= '1';
                    if (Wvalid='1')
                       then 
                            fstateW   <= S3;
                       else 
                            fstateW <= S2;
                    end if;  

         when S3 => 
                    Bvalid <= '1';
                    if (Bready='1')
                       then 
                            fstateW   <= S1;
                       else 
                            fstateW <= S3;
                    end if;  

      end case;
   end process;

end a;