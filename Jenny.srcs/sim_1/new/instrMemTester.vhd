--instruction memory has been tested and accuratley returns instructions from any address
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity instrMemTester is
end instrMemTester;

architecture Behavioral of instrMemTester is
    component imem is -- instruction memory
      port(addr:  in  STD_LOGIC_VECTOR(15 downto 0);
           instr: out STD_LOGIC_VECTOR(31 downto 0));
      end component;
signal addr :STD_LOGIC_VECTOR(15 downto 0);
signal instr :std_logic_vector(31 downto 0);
begin
clkprocess :process
 begin
    addr <= "0000000000000000";
    wait for 10 ns;
    addr(2 downto 0) <= "001";
    wait for 10ns;
    addr(2 downto 0) <= "010";
    wait for 10ns;
    addr(2 downto 0) <= "011";  
    wait for 10ns;
end process;

    mem: imem port map(addr=>addr, instr=>instr);

end Behavioral;
