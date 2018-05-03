library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity rotator is -- Rotates a_n registers into other alus
  port(a0, a1, a2, a3:  in    STD_LOGIC_VECTOR(31 downto 0);
        rot:            in    STD_LOGIC_VECTOR(1  downto 0);
        --a prime values (values after rotation)
       a0n,a1n,a2n,a3n: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of rotator is
signal a0m,a1m,a2m,a3m: STD_LOGIC_VECTOR(31 downto 0);
begin
    -- Rotates all data to there right rotation amount
    a0m <= a0 when rot(1) = '0' else a2;
    a1m <= a1 when rot(1) = '0' else a3;
    a2m <= a2 when rot(1) = '0' else a0;
    a3m <= a3 when rot(1) = '0' else a1;

    a0n <= a0m when rot(0) = '0' else a1m;
    a1n <= a1m when rot(0) = '0' else a2m;
    a2n <= a2m when rot(0) = '0' else a3m;
    a3n <= a3m when rot(0) = '0' else a0m;
end;
