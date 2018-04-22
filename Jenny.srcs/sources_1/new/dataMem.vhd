------------------------------------------------------------------------------
-- Data Memory
------------------------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all;  
use IEEE.NUMERIC_STD.all;

entity dmem is -- data memory
  port(clk, we:  in STD_LOGIC;
       dat:    in STD_LOGIC_VECTOR(127 downto 0);
       addr:    in STD_LOGIC_VECTOR(15 downto 0);
       rd:       out STD_LOGIC_VECTOR(127 downto 0));
end;

architecture behave of dmem is
  type ramtype is array (6000 downto 0) of STD_LOGIC_VECTOR(127 downto 0);
  signal mem: ramtype;
begin
  process ( clk, dat ) is
  begin
  --write data to file
    if clk'event and clk = '1' then
        if (we = '1') then 
			mem( to_integer(unsigned(addr(15 downto 0))) ) <= dat;
        end if;
    end if;
    rd <= mem( to_integer(unsigned(addr(15 downto 0))) ); -- word aligned
  end process;
end;