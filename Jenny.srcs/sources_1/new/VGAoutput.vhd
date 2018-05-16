--File that takes data from JENNY GPU and outputs it to screen
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VGAoutput is
      Port (clk: in STD_LOGIC;
            resetSW: in STD_LOGIC;
            hsync, vsync: out STD_LOGIC;
            red, green, blue: out STD_LOGIC_VECTOR(3 downto 0);
            point1x,point2x,point3x,point4x,point5x,point6x,point7x,point8x: in STD_LOGIC_VECTOR(31 downto 0);
            point1y,point2y,point3y,point4y,point5y,point6y,point7y,point8y: in STD_LOGIC_VECTOR(31 downto 0));
            --file takes in coordinates for all points calculated by JENNY
            
            --also take in and put out VGA stuff.
            
end VGAoutput;

architecture Behavioral of VGAoutput is
    
    component vga_sync
    port(
          clk, reset: in std_logic;
          hsync, vsync: out std_logic;
          video_on, p_tick: out std_logic;
          pixel_x, pixel_y: out std_logic_vector (9 downto 0)
        );
    end component;
    
    signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
    signal video_on, pixel_tick: std_logic;
    signal red_reg, red_next: std_logic_vector(3 downto 0) := (others => '0');
    signal green_reg, green_next: std_logic_vector(3 downto 0) := (others => '0');
    signal blue_reg, blue_next: std_logic_vector(3 downto 0) := (others => '0'); 

begin

   vga_sync_unit: vga_sync port map(clk => clk, reset => resetSW, hsync => hsync, vsync => vsync, pixel_x => pixel_x, pixel_y => pixel_y, video_on => video_on, p_tick => pixel_tick);

  process ( pixel_x, pixel_y )
  begin
    
  end process;

--print points to screen and make lines between them
 -- generate r,g,b registers
  process ( video_on, pixel_tick, red_next, green_next, blue_next)
  begin
     if rising_edge(pixel_tick) then
         if (video_on = '1') then
           red_reg <= red_next;
           green_reg <= green_next;
           blue_reg <= blue_next;   
         else
           red_reg <= "0000";
           green_reg <= "0000";
           blue_reg <= "0000";                    
         end if;
     end if;
  end process;
  
  red <= STD_LOGIC_VECTOR(red_reg);
  green <= STD_LOGIC_VECTOR(green_reg); 
  blue <= STD_LOGIC_VECTOR(blue_reg);


end Behavioral;

