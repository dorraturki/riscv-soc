library ieee;
use ieee.std_logic_1164.all;

library soc;
use soc.pack_axi_types.all;
use soc.pack_soc_components.all;

entity RAM_2pNx4s_axi is
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
end entity;

architecture a of RAM_2pNx4s_axi is

   for U : RAM_2pNx4s use entity soc.RAM_2pNx4s(a);

   type stateR is (S0,S1,S2);

   signal pstateR : stateR;
   signal fstateR : stateR;

   type stateW is (S0,S1,S2,S3);

   signal pstateW : stateW;
   signal fstateW : stateW;

   signal RnW         : std_logic;
   signal address     : std_logic_vector(32-1 downto 2);
   signal address_reg : std_logic_vector(32-1 downto 2);
   signal BE          : std_logic_vector( 4-1 downto 0);

begin

   --Registre d'adresses
   process(clk)
   begin
      if rising_edge(clk)
         then    if (reset  ='1'                ) then address_reg <= (others=>'0');
              elsif (AWvalid='1' and AWready='1') then address_reg <= AWpayld.addr;
                                                  else address_reg <= address_reg;
              end if;
      end if;
   end process;

   --Registres d'état des FSMs
   process(clk)
   begin
      if rising_edge(clk)
         then    if (reset  ='1') then pstateR <= S0     ; pstateW <= S0     ;
              elsif (enable ='1') then pstateR <= fstateR; pstateW <= fstateW;
                                  else pstateR <= pstateR; pstateW <= pstateW;
              end if;
      end if;
   end process;

   --FSM lecture
		process(pstateR, ARvalid, ARready, Rvalid, Rready)
		begin
		   -- Sorties par défaut
		   ARready <= '0';
		   Rvalid  <= '0';
		   
		   -- Mise à jour des sorties selon l'état
		   case pstateR is
		   
			  when S0 => -- Initialisation
						 fstateR <= S1;
			  
			  when S1 => -- Attente et réception demande lecture
						 ARready <= '1';
						 if (ARvalid = '1')
							then -- Demande reçue
								 fstateR <= S2;
							else -- Attente
								 fstateR <= S1;
						 end if;
			  
			  when S2 => -- Envoi donnée
						 Rvalid <= '1';
						 if (Rready = '1')
							then -- Donnée envoyée => transaction terminée
								 fstateR <= S1;
							else -- Attente
								 fstateR <= S2;
						 end if;
		   
		   end case;
		end process;   
   --FSM écriture
		process(pstateW, AWvalid, AWready, Wvalid, Wready, Bvalid, Bready)
		begin
		   -- Sorties par défaut
		   AWready <= '0';
		   Wready  <= '0';
		   Bvalid  <= '0';
		   
		   -- Mise à jour des sorties selon l'état
		   case pstateW is
		   
			  when S0 => -- Initialisation
						 fstateW <= S1;
			  
			  when S1 => -- Attente et réception demande écriture
						 AWready <= '1';
						 if (AWvalid = '1')
							then -- Demande reçue
								 fstateW <= S2;
							else -- Attente
								 fstateW <= S1;
						 end if;
			  
			  when S2 => -- Réception donnée
						 Wready <= '1';
						 if (Wvalid = '1')
							then -- Donnée reçue
								 fstateW <= S3;
							else -- Attente
								 fstateW <= S2;
						 end if;
			  
			  when S3 => -- Envoi réponse
						 Bvalid <= '1';
						 if (Bready = '1')
							then -- Réponse envoyée => transaction terminée
								 fstateW <= S1;
							else -- Attente
								 fstateW <= S3;
						 end if;
		   
		   end case;
		end process;
   RnW <= '0' when Wvalid='1' and Wready='1' else '1';
   
   address <=       address_reg  when Wvalid ='1' and Wready ='1'
               else ARpayld.addr when ARvalid='1' and ARready='1'
               else (others=>'-');
              
   BE <= Wpayld.BE when Wvalid='1' and Wready='1' else (others=>'0');

   U : RAM_2pNx4s
   generic map(
      N         => N
   )
   port map(
      reset    => reset,  
      clk      => clk,    
      RnW      => RnW,
      address  => address,
      BE       => BE,
      data_in  => Wpayld.data,
      data_out => Rpayld.data
   );
   
   --Réponse en lecture
   Rpayld.resp <= "00";

   --Réponse en écriture
   Bpayld.resp <= "00";
   
end a;
