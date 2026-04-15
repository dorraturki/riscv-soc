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

   --Addresse register
   process(clk)
   begin
      if rising_edge(clk)
         then    if (reset  ='1'                ) then address_reg <= (others=>'0');
              elsif (AWvalid='1' and AWready='1') then address_reg <= AWpayld.addr;
                                                  else address_reg <= address_reg;
              end if;
      end if;
   end process;

   --FSM registers
   process(clk)
   begin
      if rising_edge(clk)
         then    if (reset  ='1') then pstateR <= S0     ; pstateW <= S0     ;
              elsif (enable ='1') then pstateR <= fstateR; pstateW <= fstateW;
                                  else pstateR <= pstateR; pstateW <= pstateW;
              end if;
      end if;
   end process;

   --FSM read
		process(pstateR, ARvalid, ARready, Rvalid, Rready)
		begin
		   -- Default outputs
		   ARready <= '0';
		   Rvalid  <= '0';
		   
		   -- Update outputs
		   case pstateR is
		   
			  when S0 => -- Initialization
						 fstateR <= S1;
			  
			  when S1 => -- Wait for reading request
						 ARready <= '1';
						 if (ARvalid = '1')
							then -- request arrived
								 fstateR <= S2;
							else -- Wait
								 fstateR <= S1;
						 end if;
			  
			  when S2 => -- Send data
						 Rvalid <= '1';
						 if (Rready = '1')
							then --Data sent => transaction finished
								 fstateR <= S1;
							else -- Wait
								 fstateR <= S2;
						 end if;
		   
		   end case;
		end process;   
   --FSM writing
		process(pstateW, AWvalid, AWready, Wvalid, Wready, Bvalid, Bready)
		begin
		   -- Default outputs
		   AWready <= '0';
		   Wready  <= '0';
		   Bvalid  <= '0';
		   
		   -- Update outputs
		   case pstateW is
		   
			  when S0 => -- Initialization
						 fstateW <= S1;
			  
			  when S1 => -- Wait for request
						 AWready <= '1';
						 if (AWvalid = '1')
							then -- Request arrived
								 fstateW <= S2;
							else -- Wait
								 fstateW <= S1;
						 end if;
			  
			  when S2 => -- Data reception
						 Wready <= '1';
						 if (Wvalid = '1')
							then -- Data received
								 fstateW <= S3;
							else -- Wait
								 fstateW <= S2;
						 end if;
			  
			  when S3 => -- Sending response
						 Bvalid <= '1';
						 if (Bready = '1')
							then -- Response sent => transaction finished
								 fstateW <= S1;
							else -- Wait
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
   
   --Response in reading
   Rpayld.resp <= "00";

   --Response in writing
   Bpayld.resp <= "00";
   
end a;
