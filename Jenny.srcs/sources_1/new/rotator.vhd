library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity rotator is -- Rotates a_n registers into other alus
  port(a0, a1, a2, a3:  in    STD_LOGIC_VECTOR(31 downto 0);
        rot:            in    STD_LOGIC_VECTOR(1  downto 0);
        --a prime values (values after rotation)
       a0n,a1n,a2n,a3n: inout STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of rotator is
begin
    -- Rotates all data to there right rotation amount
    a0n <= a0 when rot(1) = '0' else a2;
    a1n <= a1 when rot(1) = '0' else a3;
    a2n <= a2 when rot(1) = '0' else a0;
    a3n <= a3 when rot(1) = '0' else a1;

    a0n <= a0n when rot(0) = '0' else a1n;
    a1n <= a1n when rot(0) = '0' else a2n;
    a2n <= a2n when rot(0) = '0' else a3n;
    a3n <= a3n when rot(0) = '0' else a0n;
end;
