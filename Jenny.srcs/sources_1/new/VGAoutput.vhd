--File that takes data from JENNY GPU and outputs it to screen
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VGAoutput is
      Port (clk: in STD_LOGIC;
            point1x,point2x,point3x,point4x,point5x,point6x,point7x,point8x: in STD_LOGIC_VECTOR(32 downto 0);
            point1y,point2y,point3y,point4y,point5y,point6y,point7y,point8y: in STD_LOGIC_VECTOR(32 downto 0) );
            --file takes in coordinates for all points calculated by JENNY
            
            --also take in and put out VGA stuff.
            
end VGAoutput;

architecture Behavioral of VGAoutput is

begin
--print points to screen and make lines between them

end Behavioral;

