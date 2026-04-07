library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;

entity controller is
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
end entity;

architecture a of controller is

   signal opcode   : std_logic_vector(7-1 downto 0);
   signal funct3   : std_logic_vector(3-1 downto 0);
   signal funct7   : std_logic_vector(7-1 downto 0);

begin

   opcode <= inst( 6 downto  0);
   funct3 <= inst(14 downto 12);
   funct7 <= inst(31 downto 25);
   
   process(opcode,funct3,funct7,C(0))
   
      type tcontrols is record
         reg_write      : std_logic;
         PCrs1d_select  : integer range 0 to 1;
         imm4BJI_select : integer range 0 to 3;
         A_select       : integer range 0 to 1;
         B_select       : integer range 0 to 4;
         op             : toperation;
         data_write     : std_logic;
         data_read      : std_logic;
         rdd_select     : integer range 0 to 1;
      end record;

      variable controls : tcontrols;
   
   begin
      case opcode is
           when OPCODE_LOAD => --LOAD
                case funct3 is
                     when F3_LB  => decoded_inst <= INST_LB   ; controls := ('1',0,0,0,2,OP_ADD,'0','1',1);
					 when F3_LH  => decoded_inst <= INST_LH   ; controls := ('1',0,0,0,2,OP_ADD,'0','1',1);
					 when F3_LBU  => decoded_inst <= INST_LBU   ; controls := ('1',0,0,0,2,OP_ADD,'0','1',1);
					 when F3_LHU  => decoded_inst <= INST_LHU   ; controls := ('1',0,0,0,2,OP_ADD,'0','1',1);
					 when F3_LW  => decoded_inst <= INST_LW   ; controls := ('1',0,0,0,2,OP_ADD,'0','1',1);
					 when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                end case;
              
           when OPCODE_OP => --OP                                           
                case funct3 is
                     when F3_ARITH => 
                          case funct7 is
                               when F7_ADD => decoded_inst <= INST_ADD  ; controls := ('1',0,0,0,0,OP_ADD,'0','0',0);
                               when F7_SUB => decoded_inst <= INST_SUB  ; controls := ('1',0,0,0,0,OP_SUB,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;                                            
                     when F3_XOR => 
                          case funct7 is
                               when F7_XOR => decoded_inst <= INST_XOR  ; controls := ('1',0,0,0,0,OP_XOR,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case; 
					 when F3_OR => 
                          case funct7 is
                               when F7_OR => decoded_inst <= INST_OR  ; controls := ('1',0,0,0,0,OP_OR,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;	 
					when F3_AND => 
                          case funct7 is
                               when F7_AND => decoded_inst <= INST_AND  ; controls := ('1',0,0,0,0,OP_AND,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;	
					when F3_SLL => 
                          case funct7 is
                               when F7_SLL => decoded_inst <= INST_SLL  ; controls := ('1',0,0,0,0,OP_SLL,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;	
					when F3_SR => 
                          case funct7 is
                               when F7_SRL => decoded_inst <= INST_SRL  ; controls := ('1',0,0,0,0,OP_SRL,'0','0',0);
                               when F7_SRA => decoded_inst <= INST_SRA  ; controls := ('1',0,0,0,0,OP_SRA,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;	
					when F3_SLT => 
                          case funct7 is
                               when F7_SLT => decoded_inst <= INST_SLT  ; controls := ('1',0,0,0,0,OP_LT,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;	
					when F3_SLTU => 
                          case funct7 is
                               when F7_SLTU => decoded_inst <= INST_SLTU  ; controls := ('1',0,0,0,0,OP_LT,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;							  
                     when others     => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
				end case;   
				
           when OPCODE_OP_IMM => --OP-IMM
                case funct3 is
					when F3_ARITH  => decoded_inst <= INST_ADDI   ; controls := ('1',0,0,0,2,OP_ADD,'0','0',0);
					when F3_XOR  => decoded_inst <= INST_XORI   ; controls := ('1',0,0,0,2,OP_XOR,'0','0',0);	
					when F3_OR  => decoded_inst <= INST_ORI   ; controls := ('1',0,0,0,2,OP_OR,'0','0',0);
					when F3_AND  => decoded_inst <= INST_ANDI   ; controls := ('1',0,0,0,2,OP_AND,'0','0',0);
					when F3_SLT  => decoded_inst <= INST_SLTI   ; controls := ('1',0,0,0,2,OP_LT,'0','0',0);
					when F3_SLTU  => decoded_inst <= INST_SLTIU   ; controls := ('1',0,0,0,2,OP_LTU,'0','0',0);
					when F3_SLL => 
                          case funct7 is
                               when F7_SLL => decoded_inst <= INST_SLLI  ; controls := ('1',0,0,0,0,OP_SLL,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;	
					when F3_SR => 
                          case funct7 is
                               when F7_SRL => decoded_inst <= INST_SRLI  ; controls := ('1',0,0,0,0,OP_SRL,'0','0',0);
							   when F7_SRA => decoded_inst <= INST_SRAI  ; controls := ('1',0,0,0,0,OP_SRA,'0','0',0);
                               when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                          end case;			
					when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);						  
				end case;
				
		   when OPCODE_STORE => --STORE
                case funct3 is
                     when F3_SB  => decoded_inst <= INST_SB   ; controls := ('0',0,0,0,3,OP_ADD,'1','0',1);
					 when F3_SH  => decoded_inst <= INST_SH   ; controls := ('0',0,0,0,3,OP_ADD,'1','0',1);
					 when F3_SW  => decoded_inst <= INST_SW   ; controls := ('0',0,0,0,3,OP_ADD,'1','0',1);
					 when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                end case;
				
		   when OPCODE_BRANCH => --BRANCH
                case funct3 is
                     when F3_BEQ  => decoded_inst <= INST_BEQ   ; controls := ('0',0,1,0,0,OP_EQ,'0','0',0);
					 when F3_BNE  => decoded_inst <= INST_BNE   ; controls := ('0',0,1,0,0,OP_NEQ,'0','0',0);
					 when F3_BLT  => decoded_inst <= INST_BLT   ; controls := ('0',0,1,0,0,OP_LT,'0','0',0);
					 when F3_BGE  => decoded_inst <= INST_BGE   ; controls := ('0',0,1,0,0,OP_LT,'0','0',0);
					 when F3_LTU  => decoded_inst <= INST_BLTU   ; controls := ('0',0,1,0,0,OP_LTU,'0','0',0);
					 when F3_GEU  => decoded_inst <= INST_BGEU   ; controls := ('0',0,1,0,0,OP_GEU,'0','0',0);
					 when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                end case;
			
		   when OPCODE_JAL =>	--JUMP AND LINK		
				decoded_inst <= INST_JAL   ; controls := ('1',0,2,1,1,OP_ADD,'0','0',0);

		   when OPCODE_JALR =>	--JUMP AND LINK	TO register		
				case funct3 is
                     when F3_JALR  => decoded_inst <= INST_JALR   ; controls := ('1',1,3,1,1,OP_ADD,'0','0',0);
					 when others => decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
                end case;
			
		   when OPCODE_LUI =>	--JUMP AND LINK	TO register		
				decoded_inst <= INST_LUI   ; controls := ('1',0,0,0,4,OP_PASSB,'0','0',0);

		   when OPCODE_AUIPC =>	--JUMP AND LINK	TO register		
				decoded_inst <= INST_AUIPC   ; controls := ('1',0,0,1,4,OP_ADD,'0','0',0);
				
           when others => --Default
                decoded_inst <= INST_ERROR; controls := ('0',0,0,0,0,OP_ADD,'0','0',0);
      end case;
      
      reg_write      <= controls.reg_write;
      PCrs1d_select  <= controls.PCrs1d_select;
      imm4BJI_select <= controls.imm4BJI_select;
      A_select       <= controls.A_select;
      B_select       <= controls.B_select;
      op             <= controls.op;
      data_write     <= controls.data_write;
      data_read      <= controls.data_read;
      rdd_select     <= controls.rdd_select;

   end process;
   
end a;
