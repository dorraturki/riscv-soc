library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;
use RISCV.pack_RISCV32I_components.all;

library RISCV_reference;

entity tb_ALU is
end entity;

architecture a of tb_ALU is

   for DUT           : ALU use entity riscv.ALU(a);
   for DUT_reference : ALU use entity riscv_reference.ALU(a);

   signal op : toperation;
   signal a  : std_logic_vector(32-1 downto 0);
   signal b  : std_logic_vector(32-1 downto 0);
   signal c  : std_logic_vector(32-1 downto 0);

   signal c_reference : std_logic_vector(32-1 downto 0);
   signal c_ok        : boolean;

begin

   DUT : ALU
	port map(
      op => op,
      a  => a,
      b  => b,
      c  => c 
	);

   process
   begin
      -- ADD / SUB
      op <= OP_ADD;   a <= std_logic_vector(to_signed(-2,32)); b <= std_logic_vector(to_signed( 5,32)); wait for 100 ns;
      op <= OP_ADD;   a <= x"7FFFFFFF";                        b <= x"00000001";                        wait for 100 ns; 
      op <= OP_SUB;   a <= x"00000003";                        b <= x"00000001";                        wait for 100 ns;
      op <= OP_SUB;   a <= x"00000000";                        b <= x"00000001";                        wait for 100 ns; 

      -- Logique
      op <= OP_AND;   a <= x"F0F0F0F0"; b <= x"0FF00FF0";                                              wait for 100 ns;
      op <= OP_OR;    a <= x"F0F0F0F0"; b <= x"0FF00FF0";                                              wait for 100 ns;
      op <= OP_XOR;   a <= x"AAAAAAAA"; b <= x"55555555";                                              wait for 100 ns;

      -- Comparaisons
      op <= OP_EQ;    a <= x"CAFEBABE"; b <= x"CAFEBABE";                                              wait for 100 ns;
      op <= OP_NEQ;   a <= x"CAFEBABE"; b <= x"DEADBEEF";                                              wait for 100 ns;

      -- Signé / non signé
      op <= OP_LT;    a <= x"FFFFFFFF"; b <= x"00000001";                                              wait for 100 ns; -- -1 < 1  (true)
      op <= OP_LTU;   a <= x"FFFFFFFF"; b <= x"00000001";                                              wait for 100 ns; -- 0xFFFFFFFF < 1 (false)
      op <= OP_GE;    a <= x"80000000"; b <= x"80000000";                                              wait for 100 ns; -- true
      op <= OP_GEU;   a <= x"80000000"; b <= x"7FFFFFFF";                                              wait for 100 ns; -- true

      -- Décalages 
      op <= OP_SLL;   a <= x"00000001"; b <= x"0000001F";                                              wait for 100 ns; -- -> 0x80000000
      op <= OP_SRL;   a <= x"80000000"; b <= x"0000001F";                                              wait for 100 ns; -- -> 0x00000001
      op <= OP_SRA;   a <= x"80000000"; b <= x"0000001F";                                              wait for 100 ns; -- -> 0xFFFFFFFF

      -- Pass-through
      op <= OP_PASSA; a <= x"12345678"; b <= x"00000000";                                              wait for 100 ns;
      op <= OP_PASSB; a <= x"00000000"; b <= x"89ABCDEF";                                              wait for 100 ns;


   end process;

   DUT_reference : ALU
	port map(
      op => op,
      a  => a,
      b  => b,
      c  => c_reference 
	);

   --Assertions de validation
   c_ok <= true when c=c_reference else false;

end a;
