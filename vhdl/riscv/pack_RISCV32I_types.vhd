library ieee;
use ieee.std_logic_1164.all;

package pack_RISCV32I_types is
                        
   type toperation is(
      --Arithmétique entiers
      OP_ADD  ,   --Addition signée
      OP_SUB  ,   --Soustraction signée
      --Fonctions logiques
      OP_AND  ,   --ET
      OP_OR   ,   --OU
      OP_XOR  ,   --OU exclusif
      --Tests conditionnels
      OP_EQ   ,   --Egalité
      OP_NEQ  ,   --Différence
      OP_LT   ,   --Inférieur ou égal signé
      OP_LTU  ,   --Inférieur ou égal non signé
      OP_GE   ,   --Supérieur ou égal signé
      OP_GEU  ,   --Supérieur ou egal non signé
      --Décalages
      OP_SLL  ,   --Décalage logique à gauche
      OP_SRL  ,   --Décalage logique à droite
      OP_SRA  ,   --Décalage arithmétique à droite
      --Autres
      OP_PASSA,   --Copie A en sortie   
      OP_PASSB    --Copie B en sottie
   );
      
end package;

