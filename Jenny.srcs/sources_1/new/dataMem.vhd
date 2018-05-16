------------------------------------------------------------------------------
-- Data Memory
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity dmem is -- data memory
  port(clk, load,save: in  STD_LOGIC;
       dat:      in  STD_LOGIC_VECTOR(127 downto 0);
       dataaddr: in  STD_LOGIC_VECTOR(15  downto 0);
       rd:       out STD_LOGIC_VECTOR(127 downto 0));
end;

architecture behave of dmem is
    type ramtype is array (50 downto 0) of STD_LOGIC_VECTOR(127 downto 0);
    signal mem: ramtype;
    signal tester: std_logic_vector(127 downto 0);
    begin
    
    process (clk, dat) is -- Write data to file
    begin
        if clk = '1' then
            if (save = '1') then
                mem( to_integer(unsigned(dataaddr(15 downto 0))) ) <= dat;
            elsif(load= '1') then
                rd <= mem( to_integer(unsigned(dataaddr(15 downto 0))) ); -- word aligned
            end if;
        end if;
        tester <=  mem(0) ;
    end process;

end;
