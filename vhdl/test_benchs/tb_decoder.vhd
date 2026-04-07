library ieee;
use ieee.std_logic_1164.all;

library RISCV_reference;

library RISCV;
use RISCV.pack_RISCV32I_types.all;
use RISCV.pack_RISCV32I_components.all;

entity tb_decoder is
end entity;

architecture a of tb_decoder is

   for DUT           : decoder use entity riscv.decoder(a);
   for DUT_reference : decoder use entity riscv_reference.decoder(a);

   signal inst_str : string(1 to 20);
   
   signal inst : std_logic_vector(32-1 downto 0);
   signal rs1a : std_logic_vector( 5-1 downto 0);
   signal rs2a : std_logic_vector( 5-1 downto 0);
   signal rda  : std_logic_vector( 5-1 downto 0);
   signal immI : std_logic_vector(32-1 downto 0);
   signal immS : std_logic_vector(32-1 downto 0);
   signal immB : std_logic_vector(32-1 downto 0);
   signal immU : std_logic_vector(32-1 downto 0);
   signal immJ : std_logic_vector(32-1 downto 0);
 
   signal rs1a_reference : std_logic_vector( 5-1 downto 0);
   signal rs2a_reference : std_logic_vector( 5-1 downto 0);
   signal rda_reference  : std_logic_vector( 5-1 downto 0);
   signal immI_reference : std_logic_vector(32-1 downto 0);
   signal immS_reference : std_logic_vector(32-1 downto 0);
   signal immB_reference : std_logic_vector(32-1 downto 0);
   signal immU_reference : std_logic_vector(32-1 downto 0);
   signal immJ_reference : std_logic_vector(32-1 downto 0);
 
   signal OK_rs1a : boolean;
   signal OK_rs2a : boolean;
   signal OK_rda  : boolean;
   signal OK_immI : boolean;
   signal OK_immS : boolean;
   signal OK_immB : boolean;
   signal OK_immU : boolean;
   signal OK_immJ : boolean;
 
   signal OK_global : boolean;

begin

   DUT : decoder
   port map(
      inst => inst,
      rs1a => rs1a,
      rs2a => rs2a,
      rda  => rda,
      immI => immI,
      immS => immS,
      immB => immB,
      immU => immU,
      immJ => immJ
   );

   process
   begin
      --Valeur immédiate au format I positive
      -- addi x5,x0,6
      inst_str <= "addi x5,x0,6        "; inst <= x"00600293"; wait for 100 ns;
      
      --Valeur immédiate au format I négative
      inst_str <= "addi x5,x0,-6       "; inst <= x"ffa00293"; wait for 100 ns;
      
      --Valeur immédiate au format S positive
       inst_str <="sw x5, 8(x0)        "; inst <= x"00502423"; wait for 100 ns;

      --Valeur immédiate au format S négative
       inst_str <="sw x5, -8(x0)       "; inst <= x"fe502c23"; wait for 100 ns;
      
      --Valeur immédiate au format B positive
      -- current:
      --    beq x1,x2,next
      -- next:
      --    nop
      inst_str <= "beq x1,x2,next      "; inst <= x"00208263"; wait for 100 ns;
      
      --Valeur immédiate au format B négative :
      inst_str <= "beq x1,x2,-next     "; inst <= x"fe208ee3"; wait for 100 ns;
      
      --Valeur immédiate au format U 
      -- lui x23,13
      inst_str <= "lui x23,13          "; inst <= x"0000dbb7"; wait for 100 ns;

      --Valeur immédiate au format J positive :
      inst_str <= "jal x0, 4           "; inst <= x"0040006f"; wait for 100 ns;

      --Valeur immédiate au format J négative :
      inst_str <= "jal x0, -2          "; inst <= x"fffff06f"; wait for 100 ns;

      wait;
   end process;

   DUT_reference : decoder
   port map(
      inst => inst,
      rs1a => rs1a_reference,
      rs2a => rs2a_reference,
      rda  => rda_reference,
      immI => immI_reference,
      immS => immS_reference,
      immB => immB_reference,
      immU => immU_reference,
      immJ => immJ_reference
   );

   --Assertions de validation
   
   OK_rs1a <= true when rs1a = rs1a_reference else false;
   OK_rs2a <= true when rs2a = rs2a_reference else false;
   OK_rda  <= true when rda  = rda_reference  else false;
   OK_immI <= true when immI = immI_reference else false;
   OK_immS <= true when immS = immS_reference else false;
   OK_immB <= true when immB = immB_reference else false;
   OK_immU <= true when immU = immU_reference else false;
   OK_immJ <= true when immJ = immJ_reference else false;
   
   OK_global <= OK_rs1a and OK_rs2a and OK_rda and OK_immI and OK_immS and OK_immB and OK_immU and OK_immJ;
   
end a;