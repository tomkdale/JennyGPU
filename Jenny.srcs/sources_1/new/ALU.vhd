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
signal d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin

-- hardware inverter for 2's complement 
b2 <= not b when alucontrol(3) = '1' else b;

-- hardware adder
sum <= a + b2 + alucontrol(3);

-- Hardware multiplier

m0 <= a when b(0) = '1';
m1 <= (a(30 downto 0) & '0') when b(1) = '1';
m2 <= (a(29 downto 0) & "00") when b(2) = '1';
m3 <= (a(28 downto 0) & "0000") when b(3) = '1';
m4 <= (a(27 downto 0) & "00000") when b(4) = '1';
m5 <= (a(26 downto 0) & "000000") when b(5) = '1';
m6 <= (a(25 downto 0) & "0000000") when b(6) = '1';
m7 <= (a(24 downto 0) & "00000000") when b(7) = '1';
m8 <= (a(23 downto 0) & "000000000") when b(8) = '1';
m9 <= (a(22 downto 0) & "0000000000") when b(9) = '1';
m10 <= (a(21 downto 0) & "00000000000") when b(10) = '1';
m11 <= (a(20 downto 0) & "000000000000") when b(11) = '1';
m12 <= (a(19 downto 0) & "0000000000000") when b(12) = '1';
m13 <= (a(18 downto 0) & "00000000000000") when b(13) = '1';
m14 <= (a(17 downto 0) & "000000000000000") when b(14) = '1';
m15 <= (a(16 downto 0) & "0000000000000000") when b(15) = '1';
product <= m0 + m1 + m2 + m3 + m4 + m5 + m6 + m7 + m8 + m9 + m10 + m11 + m12 + m13 + m14 + m15;

--begin hardware division
--do something to calc quotient;
-- figure out simple division
--hardware division will only be able to calculate 16bit numbers because of the nature of single cycle division


--begin hardware modulus
--do something to calc modulus;
-- figure out simple modulus
--hardware modulus will only be able to calculate 16bit numbers because of the nature of single cycle modulus





-- slt should be 1 if most significant bit of sum is 1
slt <= ( const_zero(31 downto 1) & '1') when sum(31) = '1' else (others =>'0');

-- determine alu operation from alucontrol bits 0 and 1
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

