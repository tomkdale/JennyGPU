--jenny top contains datapath unit, control unit and instruction memory.
--instruction memory takes address from dp, and gives instr to dp and cu
--cu gives all control data to dp
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jenny_top is
  Port (clk: in STD_LOGIC;
       resetSW: in STD_LOGIC;
       red, green, blue: out STD_LOGIC_VECTOR(3 downto 0);
       hsync, vsync: out STD_LOGIC
       );
end jenny_top;

architecture Behavioral of jenny_top is

    component dataPath is
     port(clk, reset: in  STD_LOGIC;
          instr:      in  STD_LOGIC_VECTOR(31 downto 0);
          addrnext:   out STD_LOGIC_VECTOR(15 downto 0);
          addr:       in  STD_LOGIC_VECTOR(15 downto 0);
          -- Control unit signals
          CUbranch, CUbranchDataWrite, CUreg0enable, CUreg1enable, CUreg2enable, CUreg3enable: in STD_LOGIC;
          CUimmCalc, CUbranchZero, CUload, CUdataMemWrite: in STD_LOGIC;
          rot:        in STD_LOGIC_VECTOR(1 downto 0);
          alucontrol: in STD_LOGIC_VECTOR(3 downto 0);
          point1x,point2x,point3x,point4x,point5x,point6x,point7x,point8x: out STD_LOGIC_VECTOR(31 downto 0);
          point1y,point2y,point3y,point4y,point5y,point6y,point7y,point8y: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component controlUnit is
        port(reset:      in  STD_LOGIC;
             instr:      in  STD_LOGIC_VECTOR(31 downto 0);
             CUreg0enable, CUreg1enable, CUreg2enable, CUreg3enable, CUbranch, CUbranchDataWrite: out STD_LOGIC;
             CUimmCalc, CUbranchZero, CUload, CUdataMemWrite: out STD_LOGIC;
             rot:        out STD_LOGIC_VECTOR(1 downto 0);
             alucontrol: out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    component imem is -- instruction memory
        port(addr:  in  STD_LOGIC_VECTOR(15 downto 0);
             instr: out STD_LOGIC_VECTOR(31 downto 0));
    end component;
     
        -- The datapath needs a flip-flop register component for program counter etc.
    component flipFlop generic(width: integer);
        port(clk, reset: in  STD_LOGIC;
                      d: in  STD_LOGIC_VECTOR((width-1) downto 0);
                      q: out STD_LOGIC_VECTOR((width-1) downto 0));
    end component;
      
    component VGAoutput is
        port(clk:              in  STD_LOGIC;
             resetSW:          in  STD_LOGIC;
             hsync, vsync:     out STD_LOGIC;
             red, green, blue: out STD_LOGIC_VECTOR(3 downto 0);
             point1x,point2x,point3x,point4x,point5x,point6x,point7x,point8x: in STD_LOGIC_VECTOR(31 downto 0);
             point1y,point2y,point3y,point4y,point5y,point6y,point7y,point8y: in STD_LOGIC_VECTOR(31 downto 0));
    end component;
      
    signal addr:     STD_LOGIC_VECTOR(15 downto 0);
    signal addrnext: STD_LOGIC_VECTOR(15 downto 0);
    signal instr:    STD_LOGIC_VECTOR(31 downto 0);
    signal rot:      STD_LOGIC_VECTOR(1 downto 0);
    signal CUimmCalc, CUbranchZero, CUload, CUdataMemWrite: STD_LOGIC;
    signal CUreg0enable, CUreg1enable, CUreg2enable, CUreg3enable, CUbranch, CUbranchDataWrite :STD_LOGIC;
    signal alucontrol: STD_LOGIC_VECTOR(3 downto 0);
    signal p1x, p2x, p3x, p4x, p5x, p6x, p7x, p8x: STD_LOGIC_VECTOR(31 downto 0);
    signal p1y, p2y, p3y, p4y, p5y, p6y, p7y, p8y: STD_LOGIC_VECTOR(31 downto 0);
    signal reset: STD_LOGIC := '0';
begin

    cu: controlUnit port map(reset => reset, instr => instr, rot => rot, CUreg0enable => CUreg0enable,
        CUreg1enable => CUreg1enable, CUreg2enable => CUreg2enable, CUreg3enable => CUreg3enable, CUbranch => CUbranch, CUbranchDataWrite => CUbranchDataWrite,
        CUimmCalc => CUimmCalc, CUbranchZero => CUbranchZero, CUload => CUload, CUdataMemWrite => CUdataMemWrite, alucontrol => alucontrol); 
        
    instructionMem: imem port map(addr => addr, instr => instr);
    
    dp: datapath port map(clk => clk, reset => reset, instr => instr, addr => addr, addrnext => addrnext,
        rot => rot, CUbranch => CUbranch, CUbranchDataWrite => CUbranchDataWrite, CUreg0enable => CUreg0enable,
        CUreg1enable => CUreg1enable, CUreg2enable => CUreg2enable, CUreg3enable => CUreg3enable, CUimmCalc => CUimmCalc, CUbranchZero => CUbranchZero, CUload => CUload,
        CUdataMemWrite => CUdataMemWrite, alucontrol => alucontrol,
        point1x => p1x, point2x => p2x, point3x => p3x, point4x => p4x, point5x => p5x, point6x => p6x, point7x => p7x, point8x => p8x,
        point1y => p1y, point2y => p2y, point3y => p3y, point4y => p4y, point5y => p5y, point6y => p6y, point7y => p7y, point8y => p8y);
    
    pcCLK: flipFlop generic map(16) port map(clk => clk, reset => reset, d => addrnext, q => addr);

    vga_output: VGAoutput port map(clk => clk, resetSW => resetSW, hsync => hsync, vsync => vsync, red => red, green => green, blue => blue,
                point1x => p1x, point2x => p2x, point3x => p3x, point4x => p4x, point5x => p5x, point6x => p6x, point7x => p7x, point8x => p8x,
                point1y => p1y, point2y => p2y, point3y => p3y, point4y => p4y, point5y => p5y, point6y => p6y, point7y => p7y, point8y => p8y);
 
 
end Behavioral;
