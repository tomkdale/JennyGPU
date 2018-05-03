
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tester_ALU is
end tester_ALU;

architecture Behavioral of tester_ALU is
    signal srca : std_logic_vector(31 downto 0):= (others => '0');
    signal srcb : std_logic_vector(31 downto 0):= (others => '0');
    signal alucontrol :std_logic_vector(3 downto 0):= (others => '0');
    signal result :std_logic_vector(31 downto 0);
    signal zero : std_logic;
    signal clock: std_logic;
    component alu
      port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
           alucontrol: in  STD_LOGIC_VECTOR(3 downto 0);
           result:     inout STD_LOGIC_VECTOR(31 downto 0);
           zero:       out STD_LOGIC);
      end component;

begin
    mainalu: ALU port map(a => srca, b => srcb, alucontrol => alucontrol, result => result, zero => zero);
    timer: PROCESS
        begin
        srca(5 downto 0) <= "101101"; --45
        srcb(5 downto 0) <= "011001"; --25
        alucontrol(3 downto 0) <= "0000";--a and b
            --a and b = 001001 = 9 TRUE
        wait for 100 ns;
        alucontrol (3 downto 0) <= "0001";--a or b
            --a or b = 111101 = 61 TRUE
        wait for 100 ns;
        alucontrol (3 downto 0) <= "0010";--a + b
            --a + b = 70  TRUE
        wait for 100 ns;
        alucontrol (3 downto 0) <= "0011";--a * b
            --a * b = 1125 true
        wait for 100 ns;
        alucontrol (3 downto 0) <= "0100";--a / b
            --a / b =  1 TRUE
        wait for 100 ns;
        alucontrol (3 downto 0) <= "0101";--a slt b
            --a slt b = 0 TRUE -- also ZERO flag is set to true
        wait for 100 ns;
        alucontrol (3 downto 0) <= "0110";--a % b
        --a % b = 20 TRUE
        wait for 100 ns;
        alucontrol (3 downto 0) <= "1000";--a and ~b
        --a and ~b = 100100 TRUE
        wait for 100 ns;
        alucontrol (3 downto 0) <= "1001";--a or ~b
            --a or not b = '11111111...101111' TRUE
        wait for 100 ns;
        alucontrol (3 downto 0) <= "1010";--a - b
            --a - b = 20 TRUE
        wait for 100 ns;
                    
            --now showing huge number examples to show 16 bit error
        srca(15 downto 0) <= "0000101110111000"; --3,000
        srcb(15 downto 0) <= "1010010000010000"; --42,000
        alucontrol (3 downto 0) <= "0010";
            --a + b = 45,000 true , addition is exact for up to 32 bits
        wait for 100 ns;
        alucontrol (3 downto 0) <= "0011";
            --a * b = 126,000,405 FALSE (has slight error (+405) because over 2^16. This is the same with mult, div, and mod)
        wait for 100 ns;
              
    end process;
end Behavioral;
