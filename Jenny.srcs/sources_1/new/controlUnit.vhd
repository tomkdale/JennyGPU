library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlUnit is
    port(reset:     in STD_LOGIC;
    instr:          in STD_LOGIC_VECTOR(31 downto 0);
    CUreg0enable,CUreg1enable,CUreg2enable,CUreg3enable,CUbranch,CUbranchDataWrite:   out STD_LOGIC;
          CUimmCalc,CUbranchZero,CUload,CUdataMemWrite:        out STD_LOGIC;
          rot:         out     STD_LOGIC_VECTOR(1  downto 0);
          alucontrol:        out     STD_LOGIC_VECTOR(3  downto 0));
end controlUnit;

architecture Behavioral of controlUnit is
signal  allcontrol: STD_LOGIC_VECTOR(15 downto 0);
begin
   process(instr) begin
        case instr(27 downto 22) is
           when  "000001" => allcontrol <= instr(31 downto 28) & "000000000010" ; --vadd
           when  "000010" => allcontrol <= instr(31 downto 28) & "000000001010" ;--vsub
           when  "000011" => allcontrol <= instr(31 downto 28) & "000000000011" ;--vmult
           when  "000100" => allcontrol <= instr(31 downto 28) & "000000000100";--vdiv
           when  "000101" => allcontrol <= instr(31 downto 28) & "000000000101";--vmod
           when  "000110" => allcontrol <= instr(31 downto 28) & "100100000110";--blt
           when  "000111" => allcontrol <= instr(31 downto 28) & "000000" & instr(1 downto 0) & "0111";--rotate
           when  "001000" => allcontrol <= "0000100000000000";--jump
           when  "001001" => allcontrol <= instr(31 downto 28) & "001000000010";--vaddi
           when  "001010" => allcontrol <= instr(31 downto 28) & "000010000111";--loadv
           when  "001011" => allcontrol <= instr(31 downto 28) & "000001000111";--savev
           when others => allcontrol <= "0000000000000000";
    end case;
    end process;
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
