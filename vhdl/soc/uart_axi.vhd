library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library soc;
use soc.pack_axi_types.all;

library uart;
use uart.pack_uart_components.all;

entity uart_axi is
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
      RX       : in  std_logic;
      TX       : out std_logic
   );
end entity;

architecture a of uart_axi is

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
   
   UART_RX_SIM : if (SIMULATION=true) generate

      process(reset,clk)
         variable l : line;
         variable c : character;
      begin
         if (reset='0')
            then if (clk'event and clk='1')
                    then if (Rvalid='1' and Rready='1')
                            then if (l'length=0)
                                    then readline(input, l);
                                 end if;
                                 read(l,c);
                                 Rpayld.data(31 downto 8) <= (others=>'-');
                                 Rpayld.data( 7 downto 0) <= std_logic_vector(to_unsigned(character'pos(c), 8));
                         end if;
                 end if;
         end if;
      end process;

   end generate;

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

   UART_TX_SIM : if (SIMULATION=true) generate

      process(reset,clk)
         variable l : line;
      begin
         if (reset='0')
            then if (clk'event and clk='1')
                    then if (Wvalid='1' and Wready='1' and Wpayld.BE(0)='1')
                            then if (  (unsigned(Wpayld.data(7 downto 0))=character'pos(LF)))
                                    then writeline(output, l);
                                    else write(l, character'val(to_integer(unsigned(Wpayld.data(7 downto 0)))));
                                 end if;
                         end if;
                 end if;
         end if;
      end process;

   end generate;
   
end a;