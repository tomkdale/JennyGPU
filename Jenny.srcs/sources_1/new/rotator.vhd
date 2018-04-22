library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity rotator is -- rotates a_n registers into other alus
  generic(width: integer);
  port(a0, a1, a2, a3: in  STD_LOGIC_VECTOR(width-1 downto 0);
        rot: in STD_LOGIC_VECTOR(1 downto 0);
        --a prime values (values after rotation)
       a0p,a1p,a2p,a3p:      inout STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture behave of rotator is
begin
--rotates all data to there right rotation amount
    a0p <= a0 when rot(1) = '0' else a2;
    a1p <= a1 when rot(1) = '0' else a3;
    a2p <= a2 when rot(1) = '0' else a0;
    a3p <= a3 when rot(1) = '0' else a1;
    
    a0p <= a0p when rot(0) = '0' else a1p;
    a1p <= a1p when rot(0) = '0' else a2p;
    a2p <= a2p when rot(0) = '0' else a3p;
    a3p <= a3p when rot(0) = '0' else a0p;
end;