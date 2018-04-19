
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tester_ALU is
end tester_ALU;

architecture Behavioral of tester_ALU is
    signal srca : std_logic_vector(15 downto 0) :="0000000000000001";
    signal srcb : std_logic_vector(15 downto 0) :="0000000000000001";
    signal alucontrol :std_logic_vector(3 downto 0) := "0010";
    signal result :std_logic_vector(15 downto 0);
    signal zero : std_logic;
    
    component alu generic(width: integer);
      port(a, b:       in  STD_LOGIC_VECTOR((width-1) downto 0);
           alucontrol: in  STD_LOGIC_VECTOR(3 downto 0);
           result:     inout STD_LOGIC_VECTOR((width-1) downto 0);
           zero:       out STD_LOGIC);
      end component;

begin
    mainalu: ALU
     generic map(16) port map(a => srca, b => srcb, alucontrol => alucontrol, result => result, zero => zero);

end Behavioral;
