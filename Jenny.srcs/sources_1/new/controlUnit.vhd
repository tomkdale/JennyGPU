library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlUnit is
    port(reset:     in STD_LOGIC;
    instr:          in STD_LOGIC_VECTOR(10 downto 0);
    rot:            in STD_LOGIC_VECTOR(1 downto 0);
    CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite:   out STD_LOGIC;
          CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:        out STD_LOGIC;
          CUrotator:         out     STD_LOGIC_VECTOR(1  downto 0);
          alucontrol:        out     STD_LOGIC_VECTOR(3  downto 0));
end controlUnit;

architecture Behavioral of controlUnit is
signal  allcontrol: STD_LOGIC_VECTOR(15 downto 0);
begin
allcontrol <= instr(10 downto 7) & "000000000010" when instr(6 downto 0) = "0000001";--vadd
allcontrol <= instr(10 downto 7) & "000000001010" when instr(6 downto 0) = "0000010";--vsub
allcontrol <= instr(10 downto 7) & "000000000011" when instr(6 downto 0) = "0000011";--vmult
allcontrol <= instr(10 downto 7) & "000000000100" when instr(6 downto 0) = "0000100";--vdiv
allcontrol <= instr(10 downto 7) & "0000000000000101" when instr(6 downto 0) = "0000110";--vmod
allcontrol <= instr(10 downto 7) & "1001000000000110" when instr(6 downto 0) = "0000101";--blt
allcontrol <= instr(10 downto 7) & "0000000000" & rot & "0111" when instr(6 downto 0) = "0000111";--rotate
allcontrol <= "0000100000000000" when instr(6 downto 0) = "0001000";--jump
allcontrol <= instr(10 downto 7) & "001000000010" when instr(6 downto 0) = "010XXXX";--vaddi
allcontrol <= instr(10 downto 7) & "000010000111" when instr(6 downto 0) = "011XXXX";--loadv
allcontrol <= instr(10 downto 7) & "000001000111" when instr(6 downto 0) = "100XXXX";--savev


end Behavioral;
