
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;

entity ALU is
  port(
    op : in  toperation;
    a  : in  std_logic_vector(31 downto 0);
    b  : in  std_logic_vector(31 downto 0);
    c  : out std_logic_vector(31 downto 0)
  );
end entity;

architecture a of ALU is
  function one32 return std_logic_vector is
    variable v : std_logic_vector(31 downto 0) := (others => '0');
  begin v(0) := '1'; return v; end;
  function shamt(bv : std_logic_vector(31 downto 0)) return natural is
  begin return to_integer(unsigned(bv(4 downto 0))); end;
begin
  process(op, a, b)
    variable y : std_logic_vector(31 downto 0);
  begin
    case op is
      -- arithmetic
      when OP_ADD   => y := std_logic_vector(signed(a) + signed(b));
      when OP_SUB   => y := std_logic_vector(signed(a) - signed(b));
      -- logic
      when OP_AND   => y := a and b;
      when OP_OR    => y := a or  b;
      when OP_XOR   => y := a xor b;
      -- compares (boolean in bit0)
      when OP_EQ    => y := (others=>'0'); if a=b then y:=one32; end if;
      when OP_NEQ   => y := (others=>'0'); if a/=b then y:=one32; end if;
      when OP_LT    => y := (others=>'0'); if signed(a)  <  signed(b)  then y:=one32; end if;
      when OP_LTU   => y := (others=>'0'); if unsigned(a) <  unsigned(b) then y:=one32; end if;
      when OP_GE    => y := (others=>'0'); if signed(a)  >= signed(b)  then y:=one32; end if;
      when OP_GEU   => y := (others=>'0'); if unsigned(a) >= unsigned(b) then y:=one32; end if;
      -- shifts (shamt in b[4:0])
      when OP_SLL   => y := std_logic_vector(shift_left (unsigned(a), shamt(b)));
      when OP_SRL   => y := std_logic_vector(shift_right(unsigned(a), shamt(b)));
      when OP_SRA   => y := std_logic_vector(shift_right(  signed(a),  shamt(b)));
      -- pass-through
      when OP_PASSA => y := a;
      when OP_PASSB => y := b;
      -- default
      when others   => y := (others => '0');
    end case;
    c <= y;
  end process;
end architecture;
