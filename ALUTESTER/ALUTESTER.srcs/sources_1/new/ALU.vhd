library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.all;

entity ALU is
    port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(3 downto 0);
       result:     inout STD_LOGIC_VECTOR(31 downto 0);
       zero:       out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
  signal b2,b3, sum, slt: STD_LOGIC_VECTOR(31 downto 0);
  --signal product, quotient: integer;
  
signal const_zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal product : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal quotient : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal modulus : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal a0, a1, a2,   a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
--signal q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal q : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin

-- hardware inverter for 2's complement 
b2 <= not b when alucontrol(3) = '1' else b;

-- hardware adder
sum <= a + b2 + alucontrol(3);

-- Hardware multiplier

m0  <= a when b(0) = '1';
m1  <= (a(30 downto 0) & '0') when b(1) = '1';
m2  <= (a(29 downto 0) & "00") when b(2) = '1';
m3  <= (a(28 downto 0) & "000") when b(3) = '1';
m4  <= (a(27 downto 0) & "0000") when b(4) = '1';
m5  <= (a(26 downto 0) & "00000") when b(5) = '1';
m6  <= (a(25 downto 0) & "000000") when b(6) = '1';
m7  <= (a(24 downto 0) & "0000000") when b(7) = '1';
m8  <= (a(23 downto 0) & "00000000") when b(8) = '1';
m9  <= (a(22 downto 0) & "000000000") when b(9) = '1';
m10 <= (a(21 downto 0) & "0000000000") when b(10) = '1';
m11 <= (a(20 downto 0) & "00000000000") when b(11) = '1';
m12 <= (a(19 downto 0) & "000000000000") when b(12) = '1';
m13 <= (a(18 downto 0) & "0000000000000") when b(13) = '1';
m14 <= (a(17 downto 0) & "00000000000000") when b(14) = '1';
m15 <= (a(16 downto 0) & "000000000000000") when b(15) = '1';
product <= m0 + m1 + m2 + m3 + m4 + m5 + m6 + m7 + m8 + m9 + m10 + m11 + m12 + m13 + m14 + m15;


-- Hardware divider
d15 <= '0' & b(15 downto 0) & "000000000000000";
d14 <= "00" & b(15 downto 0) & "00000000000000";
d13 <= "000" & b(15 downto 0) & "0000000000000";
d12 <= "0000" & b(15 downto 0) & "000000000000";
d11 <= "00000" & b(15 downto 0) & "00000000000";
d10 <= "000000" & b(15 downto 0) & "0000000000";
d9  <= "0000000" & b(15 downto 0) & "000000000";
d8  <= "00000000" & b(15 downto 0) & "00000000";
d7  <= "000000000" & b(15 downto 0) & "0000000";
d6  <= "0000000000" & b(15 downto 0) & "000000";
d5  <= "00000000000" & b(15 downto 0) & "00000";
d4  <= "000000000000" & b(15 downto 0) & "0000";
d3  <= "0000000000000" & b(15 downto 0) & "000";
d2  <= "00000000000000" & b(15 downto 0) & "00";
d1  <= "000000000000000" & b(15 downto 0) & "0";
d0  <= "0000000000000000" & b(15 downto 0);

a0 <= a;

a1 <=       a0 - d15 when a0 >= d15 else a0;
q(15) <=    '1'      when a0 >= d15 else '0';
--
a2 <=       a1 - d14 when a1 >= d14 else a1;
q(14) <=    '1'      when a1 >= d14 else '0';
--
a3 <=       a2 - d13 when a2 >= d13 else a2;
q(13) <=    '1'      when a2 >= d13 else '0';

a4 <=       a3 - d12 when a3 >= d12 else a3;
q(12) <=    '1'      when a3 >= d12 else '0';

a5 <=       a4 - d11 when a4 >= d11 else a4;
q(11) <=    '1'      when a4 >= d11 else '0';

a6 <=       a5 - d10 when a5 >= d10 else a5;
q(10) <=    '1'      when a5 >= d10 else '0';

a7 <=       a6 - d9  when a6 >= d9  else a6;
q(9) <=    '1'       when a6 >= d9  else '0';

a8 <=       a7 - d8  when a7 >= d8  else a7;
q(8) <=    '1'       when a7 >= d8  else '0';

a9 <=       a8 - d7  when a8 >= d7  else a8;
q(7) <=    '1'       when a8 >= d7  else '0';

a10 <=      a9 - d6  when a9 >= d6  else a9;
q(6) <=    '1'       when a9 >= d6  else '0';
--
a11 <=      a10 - d5 when a10 >= d5 else a10;
q(5) <=    '1'       when a10 >= d5 else '0';
--
a12 <=      a11 - d4 when a11 >= d4 else a11;
q(4) <=    '1'       when a11 >= d4 else '0';

a13 <=      a12 - d3 when a12 >= d3 else a12;
q(3) <=    '1'       when a12 >= d3 else '0';

a14 <=      a13 - d2 when a13 >= d2 else a13;
q(2) <=    '1'       when a13 >= d2 else '0';

a15 <=      a14 - d1 when a14 >= d1 else a14;
q(1) <=    '1'       when a14 >= d1 else '0';

a16 <=      a15 - d0 when a15 >= d0 else a15;
q(0) <=    '1'       when a15 >= d0 else '0';

modulus <= a16;
quotient <= "0000000000000000" & q;



--begin hardware modulus
--do something to calc modulus;
-- figure out simple modulus
--hardware modulus will only be able to calculate 16bit numbers because of the nature of single cycle modulus

-- slt should be 1 if most significant bit of sum is 1
slt <= ( const_zero(31 downto 1) & '1') when sum(31) = '1' else (others =>'0');




with alucontrol(2 downto 0) select result <=
  a and b when "000",
  a or b  when "001",
  sum     when "010",
  product when "011",
  quotient when "100",
  slt     when "101",
  modulus when "110",
  const_zero  when others;
  
-- set the zero flag if result is 0
zero <= '1' when result = const_zero else '0';




end;

