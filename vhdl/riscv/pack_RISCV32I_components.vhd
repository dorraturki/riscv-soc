library ieee;
use ieee.std_logic_1164.all;

library riscv;
use riscv.pack_RISCV32I_types.all;

package pack_RISCV32I_components is

   component RegBank
      port(
         --Contrôles
         reset        : in  std_logic;
         clk          : in  std_logic;
         enable       : in  std_logic;
         --Ports de lecture
         address_out1 : in  std_logic_vector( 5-1 downto 0);
         data_out1    : out std_logic_vector(32-1 downto 0);
         address_out2 : in  std_logic_vector( 5-1 downto 0);
         data_out2    : out std_logic_vector(32-1 downto 0);
         --Port d'écriture
         wr           : in  std_logic;
         address_in   : in  std_logic_vector( 5-1 downto 0);
         data_in      : in  std_logic_vector(32-1 downto 0)
      );
   end component;

   component ALU
      port(
         op    : in  toperation;
         a     : in  std_logic_vector(32-1 downto 0);
         b     : in  std_logic_vector(32-1 downto 0);
         c     : out std_logic_vector(32-1 downto 0)
      );
   end component;

   component BE_generator
      port(
         inst    : in  std_logic_vector(32-1 downto 0);
         address : in  std_logic_vector( 2-1 downto 0);
         BE      : out std_logic_vector( 4-1 downto 0)
      );
   end component;

   component input_data_manager
      port(
         inst     : in  std_logic_vector(32-1 downto 0);
         BE       : in  std_logic_vector( 4-1 downto 0);
         data_in  : in  std_logic_vector(32-1 downto 0);
         data_out : out std_logic_vector(32-1 downto 0)
      );
   end component;

   component output_data_manager
      port(
         inst     : in  std_logic_vector(32-1 downto 0);
         data_in  : in  std_logic_vector(32-1 downto 0);
         data_out : out std_logic_vector(32-1 downto 0)
      );
   end component;

   component decoder
      port(
         inst : in  std_logic_vector(32-1 downto 0);
         rs1a : out std_logic_vector( 5-1 downto 0);
         rs2a : out std_logic_vector( 5-1 downto 0);
         rda  : out std_logic_vector( 5-1 downto 0);
         immI : out std_logic_vector(32-1 downto 0);
         immS : out std_logic_vector(32-1 downto 0);
         immB : out std_logic_vector(32-1 downto 0);
         immU : out std_logic_vector(32-1 downto 0);
         immJ : out std_logic_vector(32-1 downto 0)
      );
   end component;

   component controller
      port(
         inst          : in  std_logic_vector(32-1 downto 0);
         C             : in  std_logic_vector(32-1 downto 0);
         decoded_inst  : out tinstruction;
         reg_write     : out std_logic;
         PCrs1d_select : out integer range 0 to 1;
         imm4BJI_select: out integer range 0 to 3;
         A_select      : out integer range 0 to 1;
         B_select      : out integer range 0 to 4;
         op            : out toperation;
         data_write    : out std_logic;
         data_read     : out std_logic;
         rdd_select    : out integer range 0 to 1
      );
   end component;

end package;

