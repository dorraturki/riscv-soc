library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV_reference;

library RISCV;
use RISCV.pack_RISCV32I_types.all;
use RISCV.pack_RISCV32I_components.all;

entity tb_RegBank is
end entity;

architecture a of tb_RegBank is

   for DUT           : RegBank use entity riscv.RegBank(a);
   for DUT_reference : RegBank use entity riscv_reference.RegBank(a);
    
   signal reset        : std_logic;
   signal clk          : std_logic:='0';
   signal enable       : std_logic;
   signal address_out1 : std_logic_vector( 5-1 downto 0);
   signal data_out1    : std_logic_vector(32-1 downto 0);
   signal address_out2 : std_logic_vector( 5-1 downto 0);
   signal data_out2    : std_logic_vector(32-1 downto 0);
   signal wr           : std_logic;
   signal address_in   : std_logic_vector( 5-1 downto 0);
   signal data_in      : std_logic_vector(32-1 downto 0);

   signal data_out1_reference : std_logic_vector(32-1 downto 0);
   signal data_out2_reference : std_logic_vector(32-1 downto 0);

   signal data_out1_ok : boolean;
   signal data_out2_ok : boolean;
   signal global_ok    : boolean;
      
begin   

   reset <= '1', '0' after 120 ns;
   
   clk   <= not clk after 50 ns;
   
   enable <= '1';
   
   DUT : RegBank
   port map(
      --Contrôles
      reset        => reset,
      clk          => clk,
      enable       => enable,
      --Ports de lecture
      address_out1 => address_out1,
      data_out1    => data_out1,
      address_out2 => address_out2,
      data_out2    => data_out2,

      --Port d'écriture
      wr           => wr,
      address_in   => address_in,
      data_in      => data_in
   );
   
   process
   begin
      wr <= '0';
      address_out1 <= "00000";
      address_out2 <= "00000";
      wait for 160 ns;
      --Ecriture dans la banque
      wr <= '1';
      for i in 0 to 32-1 loop
         address_in <= std_logic_vector(to_unsigned(i,5));
         data_in    <= std_logic_vector(to_unsigned(i,32));
         wait for 100 ns;
      end loop;
      wr <= '0';
      wait for 300 ns;
      --Lecture dans la banque
      for i in 0 to 32-1 loop
         address_out1 <= std_logic_vector(to_unsigned(i,5));
         address_out2 <= std_logic_vector(to_unsigned(31-i,5));
         wait for 100 ns;
      end loop;
      wait;
   end process;

   
   DUT_reference : RegBank
   port map(
      --Contrôles
      reset        => reset,
      clk          => clk,
      enable       => enable,
      --Ports de lecture
      address_out1 => address_out1,
      data_out1    => data_out1_reference,
      address_out2 => address_out2,
      data_out2    => data_out2_reference,

      --Port d'écriture
      wr           => wr,
      address_in   => address_in,
      data_in      => data_in
   );
   
   --Assertions de validation
   data_out1_ok <= true when data_out1=data_out1_reference else false;
   data_out2_ok <= true when data_out2=data_out2_reference else false;
   global_ok    <= true when data_out1_ok and data_out2_ok else false;
   
end a;
