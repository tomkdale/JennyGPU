library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
--dataPath Unit

entity datapath_testbench is
end;

architecture Behavioral of datapath_testbench is

    signal clk, reset : STD_LOGIC;
    signal pc : STD_LOGIC_VECTOR(15 downto 0);
    signal instr: STD_LOGIC_VECTOR(21 downto 0);
    --control unit signals
    signal CUbranch,CUbranchDataWrite,CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable: STD_LOGIC;
    signal CUimmCalc,CUbranchZero,CUload,CUdataMemWrite: STD_LOGIC;
    signal CUrotator: STD_LOGIC_VECTOR(1 downto 0);
    signal alucontrol: STD_LOGIC_VECTOR(3 downto 0);

    component dataPath is
        port(clk, reset : in  STD_LOGIC;
          pc:                                                   inout STD_LOGIC_VECTOR(15 downto 0);
          instr:                                                in  STD_LOGIC_VECTOR(21 downto 0);
           --control unit signals
          CUbranch,CUbranchDataWrite,CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable:   in STD_LOGIC;
          CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:         in STD_LOGIC;
          CUrotator:                                            in STD_LOGIC_VECTOR(1 downto 0);
          alucontrol:                                           in  STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
begin
  maindatapath: dataPath port map(
    clk => clk,
    reset => reset,
    pc => pc, 
    instr => instr, 
    CUbranch => CUbranch, 
    CUbranchDataWrite => CUbranchDataWrite, 
    CUreg0enable => CUreg0enable,
    CUreg1enable => CUreg1enable,
    CUreg2enable => CUreg2enable,
    CUreg3enable => CUreg3enable,
    CUimmCalc => CUimmCalc,
    CUbranchZero => CUbranchZero,
    CUload => CUload,
    CUdataMemWrite => CUdataMemWrite,
    CUrotator => CUrotator,
    alucontrol => alucontrol);
 
end Behavioral;
