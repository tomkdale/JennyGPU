library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.all;

entity ALU is
    generic(width:integer);
    port(a, b:       in  STD_LOGIC_VECTOR((width-1) downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(3 downto 0);
       result:     inout STD_LOGIC_VECTOR((width-1) downto 0);
       zero:       out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
  signal b2,b3, sum, slt: STD_LOGIC_VECTOR((width-1) downto 0);
  --signal product, quotient: integer;
  
signal const_zero : STD_LOGIC_VECTOR((width-1) downto 0) := (others => '0');
signal product : STD_LOGIC_VECTOR((width-1) downto 0) := (others => '0');
signal quotient : STD_LOGIC_VECTOR((width-1) downto 0) := (others => '0');
signal modulus : STD_LOGIC_VECTOR((width-1) downto 0) := (others => '0');
begin

-- hardware inverter for 2's complement 
b2 <= not b when alucontrol(3) = '1' else b;

-- hardware adder
sum <= a + b2 + alucontrol(3);

--begin hardware multiplier
--b3 <= shift_left(signed(b2),16);
--product := product + (b3 and a(15));
--b3 <=shift_right(signed(b2),1);
--product := product + (b3 and a(14));
--...
--hardware multiplication will only be able to caluclate 16bit numbers beause of the nature of single cycle multiplication

--begin hardware division
--do something to calc quotient;
-- figure out simple division
--hardware division will only be able to calculate 16bit numbers because of the nature of single cycle division


--begin hardware modulus
--do something to calc modulus;
-- figure out simple modulus
--hardware modulus will only be able to calculate 16bit numbers because of the nature of single cycle modulus





-- slt should be 1 if most significant bit of sum is 1
slt <= ( const_zero(width-1 downto 1) & '1') when sum((width-1)) = '1' else (others =>'0');

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

