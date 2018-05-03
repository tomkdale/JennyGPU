--instruction memory has been tested and accuratley returns instructions from any address
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity controlUnitTester is
end controlUnitTester;

architecture Behavioral of controlUnitTester is
    component controlUnit is -- instruction memory
      port(reset:       in STD_LOGIC;
        instr:          in STD_LOGIC_VECTOR(31 downto 0);
        CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite:   out STD_LOGIC;
        CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:                                     out STD_LOGIC;
        rot:            out     STD_LOGIC_VECTOR(1  downto 0);
        alucontrol:     out     STD_LOGIC_VECTOR(3  downto 0));
      end component;
      
signal reset: STD_LOGIC;
signal instr: STD_LOGIC_VECTOR(31 downto 0);
signal CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite: STD_LOGIC;
signal CUimmCalc,CUbranchZero,CUload,CUdataMemWrite: STD_LOGIC;
signal rot: STD_LOGIC_VECTOR(1  downto 0);
signal alucontrol: STD_LOGIC_VECTOR(3  downto 0);

begin
clkprocess :process
 begin
    instr <= "11110010010000000000001000000001";
    wait for 10ns;

end process;

    cu: controlUnit port map(reset=>reset, instr=>instr, CUreg0enable=>CUreg0enable, 
    CUreg1enable=>CUreg1enable, CUreg2enable=>CUreg2enable, CUreg3enable=>CUreg3enable, 
    CUbranch=>CUbranch, CUbranchDataWrite=>CUbranchDataWrite, CUimmCalc=>CUimmCalc, 
    CUbranchZero=>CUbranchZero, CUload=>CUload, CUdataMemWrite=>CUdataMemWrite,
    rot=>rot, alucontrol=>alucontrol);

end Behavioral;
