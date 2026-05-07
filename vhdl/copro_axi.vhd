library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library soc;
use soc.pack_axi_types.all;

library copro;
use copro.pack_copro_components.all;

entity copro_axi is
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
      pixel_in  : in  std_logic_vector(32-1 downto 0);
      pixel_out : out std_logic_vector(32-1 downto 0)
   );
end entity;

architecture a of copro_axi is

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
      --Sorties par défaut
      ARready <= '0';
      Rvalid  <= '0';
      
      --Mise à jour des sorties par défaut
      case pstateR is

         when S0 => --Initialisation
                    fstateR <= S1;

         when S1 => --Attente d'une demande de lecture
                    ARready <= '1';
                    if (ARvalid='1')
                       then --Demande prise en compte
                            fstateR <= S2;
                       else --Attente  
                            fstateR <= S1;
                    end if;  

         when S2 => --Attente de transfert de la donnée
                    Rvalid <= '1';
                    if (Rready='1')
                       then --Transfert terminé   
                            fstateR <= S1;
                       else --Attente 
                            fstateR <= S2;
                    end if;  

      end case;
   end process;
   
   --à compléter

--Transmission
   --FSM écriture
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
      --Sorties par défaut
      AWready     <= '0';
      Wready      <= '0';
      Bvalid      <= '0';
      
      --Mise à jour des sorties par défaut
      case pstateW is

         when S0 => --Initialisation
                    fstateW <= S1;

         when S1 => --Attente d'une demande d'écriture
                    AWready <= '1';
                    if (AWvalid='1')
                       then --Demande prise en compte
                            fstateW <= S2;
                       else --Attente  
                            fstateW <= S1;
                    end if;  

         when S2 => --Attente de transfert de la donnée
                    Wready <= '1';
                    if (Wvalid='1')
                       then --Transfert terminé   
                            fstateW   <= S3;
                       else --Attente 
                            fstateW <= S2;
                    end if;  

         when S3 => --Attente de transfert de la réponse
                    Bvalid <= '1';
                    if (Bready='1')
                       then --Transfert terminé   
                            fstateW   <= S1;
                       else --Attente 
                            fstateW <= S3;
                    end if;  

      end case;
   end process;

   -- à compléter ...
   
end a;