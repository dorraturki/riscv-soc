library ieee;
use ieee.std_logic_1164.all;

library RISCV;
use RISCV.pack_RISCV32I_types.all;

entity BE_generator is
   port(
      inst    : in  std_logic_vector(32-1 downto 0);
      address : in  std_logic_vector( 2-1 downto 0);
      BE      : out std_logic_vector( 4-1 downto 0)
   );
end entity;

architecture a of BE_generator is

   signal opcode   : std_logic_vector(7-1 downto 0);
   signal funct3   : std_logic_vector(3-1 downto 0);

begin

   opcode <= inst( 6 downto  0);
   funct3 <= inst(14 downto 12);

process(opcode, funct3, address)
begin
   case opcode is
   
      -- LOAD instructions
      when OPCODE_LOAD =>
         case funct3 is
            -- LW : Load Word
            when F3_LW =>
               BE <= "1111";
            -- LH : Load Halfword (16 bits)
            when F3_LH | F3_LHU =>
               if address(1) = '0' then
                  BE <= "0011";  
               else
                  BE <= "1100";  
               end if;

            -- LB : Load Byte (8 bits)
            when F3_LB | F3_LBU =>
               case address(1 downto 0) is
                  when "00" => BE <= "0001"; -- octet 0
                  when "01" => BE <= "0010"; -- octet 1
                  when "10" => BE <= "0100"; -- octet 2
                  when "11" => BE <= "1000"; -- octet 3
                  when others => BE <= "0000";
               end case;

            when others =>
               BE <= "0000";
         end case;

      -- STORE instructions
      when OPCODE_STORE =>
         case funct3 is
            -- SW : Store Word 
            when F3_SW =>
               BE <= "1111";

            -- SH : Store Halfword 
            when F3_SH =>
               if address(1) = '0' then
                  BE <= "0011"; 
               else
                  BE <= "1100"; 
               end if;

            -- SB : Store Byte
            when F3_SB =>
               case address(1 downto 0) is
                  when "00" => BE <= "0001"; -- octet 0
                  when "01" => BE <= "0010"; -- octet 1
                  when "10" => BE <= "0100"; -- octet 2
                  when "11" => BE <= "1000"; -- octet 3
                  when others => BE <= "0000";
               end case;

            when others =>
               BE <= "0000";
         end case;

      ------------------------------------------------
      -- Other opcodes
      ------------------------------------------------
      when others =>
         BE <= "0000";

   end case;
end process;


end a;