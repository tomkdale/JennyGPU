

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
    port(resetSW : in STD_LOGIC;
        VGA_R, VGA_G, VGA_B: out STD_LOGIC_VECTOR(3 downto 0);
        VGA_HS, VGA_VS: out STD_LOGIC);
end JennyBasicTester;

architecture Behavioral of JennyBasicTester is
    component jenny_top is
      Port (clk: in STD_LOGIC;
           resetSW: in STD_LOGIC;
           SW: in STD_LOGIC_VECTOR(11 downto 0) := "100000000000";
           red, green, blue: out STD_LOGIC_VECTOR(3 downto 0);
           hsync, vsync: out STD_LOGIC
            );
    end component;
    signal reset, clk :STD_LOGIC;
    signal data0, data1, data2, data3: STD_LOGIC_VECTOR(31 downto 0);
    signal sw: STD_LOGIC_VECTOR(11 downto 0);
begin
    jenny: jenny_top port map(clk => clk, resetsw=> resetsw,
    sw => sw,
    red => VGA_R, green => VGA_G, blue => VGA_B, hsync => VGA_HS, vsync => VGA_VS);
    
    process begin
        clk <= '1';
        wait for 5 ns; 
        clk <= '0';
        wait for 5 ns;
    end process;
    
    -- Generate reset for first two clock cycles
    process begin
        reset <= '1';
        wait for 12 ns;
        reset <= '0';
        wait;
    end process;
    
end Behavioral;
