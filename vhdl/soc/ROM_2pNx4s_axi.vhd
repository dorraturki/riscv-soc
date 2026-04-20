library ieee;
use ieee.std_logic_1164.all;

library soc;
use soc.pack_axi_types.all;
use soc.pack_soc_components.all;

entity ROM_2pNx4s_axi is
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
end entity;

architecture a of ROM_2pNx4s_axi is

   for U : ROM_2pNx4s use entity soc.ROM_2pNx4s(a);

   type state is (S0,S1,S2);

   signal pstate : state;
   signal fstate : state;

begin

   --Neutralisation des écritures
   AWready <= '1';
   Wready  <= '1';
   Bvalid  <= '0'; Bpayld  <= dummyBpayld;

   --Registre d'état
   process(clk)
   begin
      if rising_edge(clk)
         then    if (reset  ='1') then pstate <= S0    ;
              elsif (enable ='1') then pstate <= fstate;
                                  else pstate <= pstate;
              end if;
      end if;
   end process;
   
   --FSM lecture
      process(pstate, ARvalid, ARready, Rvalid, Rready)
		begin
		   -- Sorties par défaut
		   ARready <= '0';
		   Rvalid  <= '0';
		   
		   -- Mise à jour des sorties selon l'état
		   case pstate is
		   
			  when S0 => -- Initialisation
						 fstate <= S1;
			  
			  when S1 => -- Attente et réception demande lecture
						 ARready <= '1';
						 if (ARvalid = '1')
							then -- Demande reçue
								 fstate <= S2;
							else -- Attente
								 fstate <= S1;
						 end if;
			  
			  when S2 => -- Envoi donnée
						 Rvalid <= '1';
						 if (Rready = '1')
							then -- Donnée envoyée => transaction terminée
								 fstate <= S1;
							else -- Attente
								 fstate <= S2;
						 end if;
		   
		   end case;
		end process;

   U : ROM_2pNx4s
   generic map(
      N         => N,
      FILE_NAME => FILE_NAME
   )
   port map(
       reset   => reset,  
       clk     => clk,    
       address => ARpayld.addr,
       data    => Rpayld.data   
   );
   
   --Réponses en lecture
   Rpayld.resp <= "00";
   
end a;