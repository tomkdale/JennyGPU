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
       rd:       out STD_LOGIC_VECTOR(127 downto 0);
       sw:       in  STD_LOGIC_VECTOR(11 downto 0);
       point1x,point2x,point3x,point4x,point5x,point6x,point7x,point8x: out STD_LOGIC_VECTOR(31 downto 0);
       point1y,point2y,point3y,point4y,point5y,point6y,point7y,point8y: out STD_LOGIC_VECTOR(31 downto 0)
       );
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
           
            mem(20) <=  (31 downto 0=>'0') & (27 downto 0 => '0') & sw(3 downto 0) & (27 downto 0 => '0') & sw(7 downto 4) & (27 downto 0 => '0') & sw(11 downto 8);
            point1x <= mem(10)(127 downto 96);
            point1y <= mem(10)(95 downto 64);
            point2x <= mem(11)(127 downto 96);
            point2y <= mem(11)(95 downto 64);
            point3x <= mem(12)(127 downto 96);
            point3y <= mem(12)(95 downto 64);
            point4x <= mem(13)(127 downto 96);
            point4y <= mem(13)(95 downto 64);
            point5x <= mem(14)(127 downto 96);
            point5y <= mem(14)(95 downto 64);
            point6x <= mem(15)(127 downto 96);
            point6y <= mem(15)(95 downto 64);
            point7x <= mem(16)(127 downto 96);
            point7y <= mem(16)(95 downto 64);
            point8x <= mem(17)(127 downto 96);
            point8y <= mem(17)(95 downto 64);
        end if;
    end process;

end;
