library ieee;
use ieee.std_logic_1164.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;
use RISCV.pack_RISCV32I_components.all;

library RISCV_reference;

entity tb_controller is
end entity;

architecture a of tb_controller is

   for DUT           : controller use entity riscv.controller(a);
   for DUT_reference : controller use entity riscv_reference.controller(a);

   signal inst_str : string(1 to 20);

   signal inst          : std_logic_vector(32-1 downto 0);
   signal C             : std_logic_vector(32-1 downto 0);
   
   signal decoded_inst  : tinstruction;
   signal reg_write     : std_logic;
   signal PCrs1d_select : integer range 0 to 1;
   signal imm4BJI_select: integer range 0 to 3;
   signal A_select      : integer range 0 to 1;
   signal B_select      : integer range 0 to 4;
   signal op            : toperation;
   signal data_write    : std_logic;
   signal data_read     : std_logic;
   signal rdd_select    : integer range 0 to 1;

   signal decoded_inst_reference  : tinstruction;
   signal reg_write_reference     : std_logic;
   signal PCrs1d_select_reference : integer range 0 to 1;
   signal imm4BJI_select_reference: integer range 0 to 3;
   signal A_select_reference      : integer range 0 to 1;
   signal B_select_reference      : integer range 0 to 4;
   signal op_reference            : toperation;
   signal data_write_reference    : std_logic;
   signal data_read_reference     : std_logic;
   signal rdd_select_reference    : integer range 0 to 1;

   signal OK_decoded_inst  : boolean;
   signal OK_reg_write     : boolean;
   signal OK_PCrs1d_select : boolean;
   signal OK_imm4BJI_select: boolean;
   signal OK_A_select      : boolean;
   signal OK_B_select      : boolean;
   signal OK_op            : boolean;
   signal OK_data_write    : boolean;
   signal OK_data_read     : boolean;
   signal OK_rdd_select    : boolean;

   signal OK_global        : boolean;
  
begin

   DUT : controller
   port map(
      inst           => inst,
      C              => C,
      decoded_inst   => decoded_inst,
      reg_write      => reg_write,
      PCrs1d_select  => PCrs1d_select,
      imm4BJI_select => imm4BJI_select,
      A_select       => A_select,
      B_select       => B_select,
      op             => op,
      data_write     => data_write,
      data_read      => data_read,
      rdd_select     => rdd_select
   );

   process
   begin
      -- lOAD
      inst_str <= "lb   x5, 0(x3)      "; inst <= x"00018283"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "lh   x5, 0(x3)      "; inst <= x"00019283"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "lbu   x5, 0(x3)     "; inst <= x"0001c283"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "lhu   x5, 0(x3)     "; inst <= x"0001d283"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "lw   x5, 0(x3)      "; inst <= x"0001a283"; c<= x"00000000"; wait for 100 ns;

      -- OP-IMM
      inst_str <= "addi  x5, x3, 1     "; inst <= x"00118293"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "slti  x5, x3, 1     "; inst <= x"0011A293"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "sltiu x5, x3, 1     "; inst <= x"0011B293"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "xori  x5, x3, 1     "; inst <= x"0011C293"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "ori   x5, x3, 1     "; inst <= x"0011E293"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "andi  x5, x3, 1     "; inst <= x"0011F293"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "slli  x5, x3, 1     "; inst <= x"00119293"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "srli  x5, x3, 1     "; inst <= x"0011D293"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "srai  x5, x3, 1     "; inst <= x"4011D293"; c<= x"00000000"; wait for 100 ns;

      -- OP (R-type)
      inst_str <= "add   x5, x3, x4    "; inst <= x"004182B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "sub   x5, x3, x4    "; inst <= x"404182B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "sll   x5, x3, x4    "; inst <= x"004192B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "slt   x5, x3, x4    "; inst <= x"0041A2B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "sltu  x5, x3, x4    "; inst <= x"0041B2B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "xor   x5, x3, x4    "; inst <= x"0041C2B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "srl   x5, x3, x4    "; inst <= x"0041D2B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "sra   x5, x3, x4    "; inst <= x"4041D2B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "or    x5, x3, x4    "; inst <= x"0041E2B3"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "and   x5, x3, x4    "; inst <= x"0041F2B3"; c<= x"00000000"; wait for 100 ns;

      -- STORE (rs2 = x5, base = x3, imm = 0)
      inst_str <= "sb    x5, 0(x3)     "; inst <= x"00518023"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "sh    x5, 0(x3)     "; inst <= x"00519023"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "sw    x5, 0(x3)     "; inst <= x"0051A023"; c<= x"00000000"; wait for 100 ns;

      -- BRANCH (offset = 0)
      inst_str <= "beq   x3, x5, 0     "; inst <= x"00518063"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "bne   x3, x5, 0     "; inst <= x"00519063"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "blt   x3, x5, 0     "; inst <= x"0051C063"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "bge   x3, x5, 0     "; inst <= x"0051D063"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "bltu  x3, x5, 0     "; inst <= x"0051E063"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "bgeu  x3, x5, 0     "; inst <= x"0051F063"; c<= x"00000000"; wait for 100 ns;

      -- JUMPS & U-type
      inst_str <= "jal   x5, 0         "; inst <= x"000002EF"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "jalr  x5, 0(x3)     "; inst <= x"000182E7"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "lui   x5, 0         "; inst <= x"000002B7"; c<= x"00000000"; wait for 100 ns;
      inst_str <= "auipc x5, 0         "; inst <= x"00000297"; c<= x"00000000"; wait for 100 ns;

      wait;
   end process;


   DUT_reference : controller
   port map(
      inst           => inst,
      C              => C,
      decoded_inst   => decoded_inst_reference,
      reg_write      => reg_write_reference,
      PCrs1d_select  => PCrs1d_select_reference,
      imm4BJI_select => imm4BJI_select_reference,
      A_select       => A_select_reference,
      B_select       => B_select_reference,
      op             => op_reference,
      data_write     => data_write_reference,
      data_read      => data_read_reference,
      rdd_select     => rdd_select_reference
   );

   OK_decoded_inst   <= true when decoded_inst   = decoded_inst_reference   else false;
   OK_reg_write      <= true when reg_write      = reg_write_reference      else false;
   OK_PCrs1d_select  <= true when PCrs1d_select  = PCrs1d_select_reference  else false;
   OK_imm4BJI_select <= true when imm4BJI_select = imm4BJI_select_reference else false;
   OK_A_select       <= true when A_select       = A_select_reference       else false;
   OK_B_select       <= true when B_select       = B_select_reference       else false;
   OK_op             <= true when op             = op_reference             else false;
   OK_data_write     <= true when data_write     = data_write_reference     else false;
   OK_data_read      <= true when data_read      = data_read_reference      else false;
   OK_rdd_select     <= true when rdd_select     = rdd_select_reference     else false;

   OK_global <= true when     (OK_decoded_inst  )
                          and (OK_reg_write     )
                          and (OK_PCrs1d_select )
                          and (OK_imm4BJI_select)
                          and (OK_A_select      )
                          and (OK_B_select      )
                          and (OK_op            )
                          and (OK_data_write    )
                          and (OK_data_read     )
                          and (OK_rdd_select    )
                          else false;

end a;