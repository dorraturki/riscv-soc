library ieee;
use ieee.std_logic_1164.all;

package pack_RISCV32I_types is
                        
   type toperation is(
      OP_ADD  ,   
      OP_SUB  ,   
      OP_AND  ,   
      OP_OR   ,   
      OP_XOR  ,   
      OP_EQ   ,   
      OP_NEQ  ,   
      OP_LT   ,   
      OP_LTU  ,   
      OP_GE   ,   
      OP_GEU  ,   
      OP_SLL  ,   
      OP_SRL  ,   
      OP_SRA  ,   
      OP_PASSA,   
      OP_PASSB    
   );

   type tinstruction is (
      INST_ADD  ,INST_SUB   ,INST_XOR ,INST_OR  ,INST_AND ,INST_SLL ,INST_SRL ,INST_SRA ,INST_SLT ,INST_SLTU ,
      INST_ADDI ,            INST_XORI,INST_ORI ,INST_ANDI,INST_SLLI,INST_SRLI,INST_SRAI,INST_SLTI,INST_SLTIU,
      INST_LB   ,INST_LH    ,INST_LW  ,INST_LBU ,INST_LHU ,
      INST_SB   ,INST_SH    ,INST_SW  ,
      INST_BEQ  ,INST_BNE   ,INST_BLT ,INST_BGE ,INST_BLTU,INST_BGEU,
      INST_JAL  ,INST_JALR  ,
      INST_LUI  ,INST_AUIPC ,
      --INST_ECALL,INST_EBREAK, INST_FENCE,
      INST_ERROR
   );

   -- RV32I Opcodes
   constant OPCODE_LOAD      : std_logic_vector(7-1 downto 0) := b"00_000_11";
   constant OPCODE_LOAD_FP   : std_logic_vector(7-1 downto 0) := b"00_001_11";
   constant OPCODE_CUSTOM_0  : std_logic_vector(7-1 downto 0) := b"00_010_11";
   constant OPCODE_MISC_MEM  : std_logic_vector(7-1 downto 0) := b"00_011_11";
   constant OPCODE_OP_IMM    : std_logic_vector(7-1 downto 0) := b"00_100_11";
   constant OPCODE_AUIPC     : std_logic_vector(7-1 downto 0) := b"00_101_11";
   constant OPCODE_OP_IMM_32 : std_logic_vector(7-1 downto 0) := b"00_110_11";

   constant OPCODE_STORE     : std_logic_vector(7-1 downto 0) := b"01_000_11";
   constant OPCODE_STORE_FP  : std_logic_vector(7-1 downto 0) := b"01_001_11";
   constant OPCODE_CUSTOM_1  : std_logic_vector(7-1 downto 0) := b"01_010_11";
   constant OPCODE_AMO       : std_logic_vector(7-1 downto 0) := b"01_011_11";
   constant OPCODE_OP        : std_logic_vector(7-1 downto 0) := b"01_100_11";
   constant OPCODE_LUI       : std_logic_vector(7-1 downto 0) := b"01_101_11";
   constant OPCODE_OP_32     : std_logic_vector(7-1 downto 0) := b"01_110_11";

   constant OPCODE_MADD      : std_logic_vector(7-1 downto 0) := b"10_000_11";
   constant OPCODE_MSUB      : std_logic_vector(7-1 downto 0) := b"10_001_11";
   constant OPCODE_NMSUB     : std_logic_vector(7-1 downto 0) := b"10_010_11";
   constant OPCODE_NMADD     : std_logic_vector(7-1 downto 0) := b"10_011_11";
   constant OPCODE_OP_FP     : std_logic_vector(7-1 downto 0) := b"10_100_11";
   constant OPCODE_OP_V      : std_logic_vector(7-1 downto 0) := b"10_101_11";
   constant OPCODE_CUSTOM_2  : std_logic_vector(7-1 downto 0) := b"10_110_11";

   constant OPCODE_BRANCH    : std_logic_vector(7-1 downto 0) := b"11_000_11";
   constant OPCODE_JALR      : std_logic_vector(7-1 downto 0) := b"11_001_11";
   constant OPCODE_JAL       : std_logic_vector(7-1 downto 0) := b"11_011_11";
   constant OPCODE_SYSTEM    : std_logic_vector(7-1 downto 0) := b"11_100_11";
   constant OPCODE_VE        : std_logic_vector(7-1 downto 0) := b"11_101_11";
   constant OPCODE_CUSTOM_3  : std_logic_vector(7-1 downto 0) := b"11_110_11";

   -- RV32I Function 3 field
   constant F3_ARITH : std_logic_vector(3-1 downto 0) := b"000";
   constant F3_SLL   : std_logic_vector(3-1 downto 0) := b"001";
   constant F3_SLT   : std_logic_vector(3-1 downto 0) := b"010";
   constant F3_SLTU  : std_logic_vector(3-1 downto 0) := b"011";
   constant F3_XOR   : std_logic_vector(3-1 downto 0) := b"100";
   constant F3_SR    : std_logic_vector(3-1 downto 0) := b"101";
   constant F3_OR    : std_logic_vector(3-1 downto 0) := b"110";
   constant F3_AND   : std_logic_vector(3-1 downto 0) := b"111";

   constant F3_LB    : std_logic_vector(3-1 downto 0) := b"000";
   constant F3_LH    : std_logic_vector(3-1 downto 0) := b"001";
   constant F3_LW    : std_logic_vector(3-1 downto 0) := b"010";
   constant F3_LBU   : std_logic_vector(3-1 downto 0) := b"100";
   constant F3_LHU   : std_logic_vector(3-1 downto 0) := b"101";

   constant F3_SB    : std_logic_vector(3-1 downto 0) := b"000";
   constant F3_SH    : std_logic_vector(3-1 downto 0) := b"001";
   constant F3_SW    : std_logic_vector(3-1 downto 0) := b"010";

   constant F3_BEQ   : std_logic_vector(3-1 downto 0) := b"000";
   constant F3_BNE   : std_logic_vector(3-1 downto 0) := b"001";
   constant F3_BLT   : std_logic_vector(3-1 downto 0) := b"100";
   constant F3_BGE   : std_logic_vector(3-1 downto 0) := b"101";
   constant F3_LTU   : std_logic_vector(3-1 downto 0) := b"110";
   constant F3_GEU   : std_logic_vector(3-1 downto 0) := b"111";

   constant F3_JALR  : std_logic_vector(3-1 downto 0) := b"000";

   -- RV32I Function 7 field
   constant F7_ADD  : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_SUB  : std_logic_vector(7-1 downto 0) := b"010_0000";
   constant F7_XOR  : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_OR   : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_AND  : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_SLL  : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_SRL  : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_SRA  : std_logic_vector(7-1 downto 0) := b"010_0000";
   constant F7_SLT  : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_SLTU : std_logic_vector(7-1 downto 0) := b"000_0000";
   
   constant F7_SLLI : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_SRLI : std_logic_vector(7-1 downto 0) := b"000_0000";
   constant F7_SRAI : std_logic_vector(7-1 downto 0) := b"010_0000";

end package;

