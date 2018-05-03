--jenny top contains datapath unit, control unit and instruction memory.
--instruction memory takes address from dp, and gives instr to dp and cu
--cu gives all control data to dp
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jenny_top is
  Port (clk, reset  :in STD_LOGIC;
       data0,data1,data2,data3 :out STD_LOGIC_VECTOR(31 downto 0)
        );
end jenny_top;

architecture Behavioral of jenny_top is

    component dataPath is
     port(clk, reset:        in     STD_LOGIC;
          instr:             in     STD_LOGIC_VECTOR(31 downto 0);
          addrnext:           out    STD_LOGIC_VECTOR(15 downto 0);
          addr:              in     STD_LOGIC_VECTOR(15 downto 0);
          data0,data1,data2,data3:             out    STD_LOGIC_VECTOR(31 downto 0);
          -- Control unit signals
          CUbranch,CUbranchDataWrite,CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable:   in STD_LOGIC;
          CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:        in STD_LOGIC;
          rot:               in STD_LOGIC_VECTOR(1 downto 0);
          alucontrol:        in     STD_LOGIC_VECTOR(3  downto 0));
    end component;

    component controlUnit is
            port(reset:     in STD_LOGIC;
            instr:          in STD_LOGIC_VECTOR(31 downto 0);
            CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite:   out STD_LOGIC;
            CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:        out STD_LOGIC;
            rot:            out STD_LOGIC_VECTOR(1 downto 0);
            alucontrol:     out     STD_LOGIC_VECTOR(3  downto 0));
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
      
     signal addr :STD_LOGIC_VECTOR(15 downto 0);
     signal addrnext        :STD_LOGIC_VECTOR(15 downto 0);
     signal instr :STD_LOGIC_VECTOR(31 downto 0);
     signal rot :STD_LOGIC_VECTOR(1 downto 0);
     signal CUimmCalc,CUbranchZero,CUload,CUdataMemWrite :STD_LOGIC;
     signal CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite :STD_LOGIC;
     signal alucontrol      :STD_LOGIC_VECTOR(3  downto 0);
begin

    cu: controlUnit port map(reset=>reset,instr=>instr,rot=>rot,CUreg0enable=>CUreg0enable,
        CUreg1enable=>CUreg1enable,CUreg2enable=>CUreg2enable,CUreg3enable=>CUreg3enable,CUbranch=>CUbranch,CUbranchDataWrite=>CUbranchDataWrite,
        CUimmCalc=>CUimmCalc,CUbranchZero=>CUbranchZero,CUload=>CUload,CUdataMemWrite=>CUdataMemWrite,alucontrol=>alucontrol); 
    instructionMem: imem port map(addr=>addr,instr=>instr);
    dp: datapath port map(clk=>clk,reset=>reset,instr=>instr,addr=>addr,addrnext=>addrnext,data0=>data0,data1=>data1,data2=>data2,data3=>data3,rot=>rot,CUbranch=>CUbranch,CUbranchDataWrite=>CUbranchDataWrite,CUreg0enable=>CUreg0enable,
    CUreg1enable=>CUreg1enable,CUreg2enable=>CUreg2enable,CUreg3enable=>CUreg3enable,CUimmCalc=>CUimmCalc,CUbranchZero=>CUbranchZero,CUload=>CUload,
    CUdataMemWrite=>CUdataMemWrite,alucontrol=>alucontrol);
   pcCLK:             flipFlop     generic map(16) port map(clk => clk, reset => reset, d => addrnext, q => addr);

 
end Behavioral;
