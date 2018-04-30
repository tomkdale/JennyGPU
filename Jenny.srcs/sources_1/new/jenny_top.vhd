
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jenny_top is
  Port (clk, reset  :in STD_LOGIC;
        data_out    :out STD_LOGIC_VECTOR(31 downto 0 ));
end jenny_top;

architecture Behavioral of jenny_top is

    component dataPath is
     port(clk, reset:        in     STD_LOGIC;
          pc:                inout  STD_LOGIC_VECTOR(15 downto 0);
          instr:             in     STD_LOGIC_VECTOR(21 downto 0);
          -- Control unit signals
          CUbranch,CUbranchDataWrite,CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable:   in STD_LOGIC;
          CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:        in STD_LOGIC;
          rot:               in STD_LOGIC_VECTOR(1 downto 0);
          alucontrol:        in     STD_LOGIC_VECTOR(3  downto 0));
    end component;

    component controlUnit is
        port(reset:     in STD_LOGIC;
        instr:          in STD_LOGIC_VECTOR(10 downto 0);
        rot:            inout STD_LOGIC_VECTOR(1 downto 0);
        CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite:   out STD_LOGIC;
              CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:        out STD_LOGIC;
              alucontrol:        out     STD_LOGIC_VECTOR(3  downto 0));
    end component;
    component imem is -- instruction memory
      generic(width: integer);
      port(a:  in  STD_LOGIC_VECTOR(5 downto 0);
           rd: out STD_LOGIC_VECTOR((width-1) downto 0));
     end component;
     signal pc :STD_LOGIC_VECTOR(15 downto 0);
     signal rot :STD_LOGIC_VECTOR(1 downto 0);
     signal rd  :STD_LOGIC_VECTOR(15 downto 0);
     signal CUimmCalc,CUbranchZero,CUload,CUdataMemWrite :STD_LOGIC;
     signal CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite :STD_LOGIC;
     signal alucontrol      :STD_LOGIC_VECTOR(3  downto 0);
begin
    instructionMem: imem generic map(16) port map(a=>pc,rd=>rd);
    dp: datapath port map(clk=>clk,reset=>reset,pc=>pc,instr=>rd,rot=>rot,CUbranch=>CUbranch,CUbranchDataWrite=>CUbranchDataWrite,CUreg0enable=>CUreg0enable,
    CUreg1enable=>CUreg1enable,CUreg2enable=>CUreg2enable,CUreg3enable=>CUreg3enable,CUimmCalc=>CUimmCalc,CUbranchZero=>CUbranchZero,CUload=>CUload,
    CUdataMemWrite=>CUdataMemWrite,alucontrol=>alucontrol);
    cu: controlUnit port map(reset=>reset,instr=>rd(15 downto 5),rot=>rot,CUreg0enable=>CUreg0enable,
        CUreg1enable=>CUreg1enable,CUreg2enable=>CUreg2enable,CUreg3enable=>CUreg3enable,CUbranch=>CUbranch,CUbranchDataWrite=>CUbranchDataWrite,
        CUimmCalc=>CUimmCalc,CUbranchZero=>CUbranchZero,CUload=>CUload,CUdataMemWrite=>CUdataMemWrite);

end Behavioral;
