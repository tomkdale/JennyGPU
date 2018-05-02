library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlUnit is
    port(reset:     in STD_LOGIC;
    instr:          in STD_LOGIC_VECTOR(12 downto 0);
    CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite:   out STD_LOGIC;
          CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:        out STD_LOGIC;
          rot:         out     STD_LOGIC_VECTOR(1  downto 0);
          alucontrol:        out     STD_LOGIC_VECTOR(3  downto 0));
end controlUnit;

architecture Behavioral of controlUnit is
signal  allcontrol: STD_LOGIC_VECTOR(15 downto 0);
begin
allcontrol <= instr(12 downto 9) & "000000000010" when instr(8 downto 2) = "0000001";--vadd
allcontrol <= instr(12 downto 9) & "000000001010" when instr(8 downto 2) = "0000010";--vsub
allcontrol <= instr(12 downto 9) & "000000000011" when instr(8 downto 2) = "0000011";--vmult
allcontrol <= instr(12 downto 9) & "000000000100" when instr(8 downto 2) = "0000100";--vdiv
allcontrol <= instr(12 downto 9) & "000000000101" when instr(8 downto 2) = "0000110";--vmod
allcontrol <= instr(12 downto 9) & "100100000110" when instr(8 downto 2) = "0000101";--blt
allcontrol <= instr(12 downto 9) & "000000" & instr(1 downto 0) & "0111" when instr(8 downto 2) = "0000111";--rotate
allcontrol <= "0000100000000000" when instr(8 downto 2) = "0001000";--jump
allcontrol <= instr(12 downto 9) & "001000000010" when instr(8 downto 2) = "010XXXX";--vaddi
allcontrol <= instr(12 downto 9) & "000010000111" when instr(8 downto 2) = "011XXXX";--loadv
allcontrol <= instr(12 downto 9) & "000001000111" when instr(8 downto 2) = "100XXXX";--savev

 CUreg0enable<= allcontrol(15);
 CUreg1enable<=allcontrol(14);
 CUreg2enable<=allcontrol(13);
 CUreg3enable<=allcontrol(12);
 CUbranch<=allcontrol(11);
 CUbranchDataWrite<=allcontrol(10);
  CUimmCalc<=allcontrol(9);
  CUbranchZero<=allcontrol(8);
  CUload<=allcontrol(7);
  CUdataMemWrite<=allcontrol(6);
  rot<=allcontrol(5 downto 4);
  alucontrol<=allcontrol(3 downto 0);


end Behavioral;
