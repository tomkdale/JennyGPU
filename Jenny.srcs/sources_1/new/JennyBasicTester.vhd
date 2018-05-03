

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity JennyBasicTester is
end JennyBasicTester;

architecture Behavioral of JennyBasicTester is
    component jenny_top is
      Port (clk, reset  :in STD_LOGIC;
           data0,data1,data2,data3 :out STD_LOGIC_VECTOR(31 downto 0)
            );
    end component;
    signal reset,clk :STD_LOGIC;
    signal data0,data1,data2,data3 : STD_LOGIC_VECTOR(31 downto 0);
               
begin

    jenny: jenny_top port map(clk=>clk,reset=>reset,data0=>data0,data1=>data1,data2=>data2,data3=>data3);
    
   process begin
        clk <= '1';
        wait for 5 ns; 
        clk <= '0';
        wait for 5 ns;
      end process;
    
      -- Generate reset for first two clock cycles
      process begin
        reset <= '1';
        wait for 22 ns;
        reset <= '0';
        wait;
      end process;
    

end Behavioral;
