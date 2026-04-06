library ieee;
use ieee.std_logic_1164.all;

package pack_RISCV32I_types is
                        
   type toperation is (
      OP_ADD  , OP_SUB ,
      OP_AND  , OP_OR  , OP_XOR,
      OP_EQ   , OP_NEQ,
      OP_LT   , OP_LTU,
      OP_GE   , OP_GEU,
      OP_SLL  , OP_SRL , OP_SRA,
      OP_PASSA, OP_PASSB
   );

   -- RV32I Opcodes
   constant OPCODE_LOAD      : std_logic_vector(7-1 downto 0) := b"00_000_11";

   constant OPCODE_STORE     : std_logic_vector(7-1 downto 0) := b"01_000_11";

   -- RV32I Function 3 field
   constant F3_LB    : std_logic_vector(3-1 downto 0) := b"000";
   constant F3_LH    : std_logic_vector(3-1 downto 0) := b"001";
   constant F3_LW    : std_logic_vector(3-1 downto 0) := b"010";
   constant F3_LBU   : std_logic_vector(3-1 downto 0) := b"100";
   constant F3_LHU   : std_logic_vector(3-1 downto 0) := b"101";

   constant F3_SB    : std_logic_vector(3-1 downto 0) := b"000";
   constant F3_SH    : std_logic_vector(3-1 downto 0) := b"001";
   constant F3_SW    : std_logic_vector(3-1 downto 0) := b"010";

end package;


