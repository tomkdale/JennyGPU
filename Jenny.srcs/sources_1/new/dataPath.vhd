
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity dataPath is
 generic(width: integer);
 port(clk, reset:        in  STD_LOGIC;
      memtoreg, pcsrc:   in  STD_LOGIC;
      alusrc, regdst:    in  STD_LOGIC;
      regwrite, jump:    in  STD_LOGIC;
      alucontrol:        in  STD_LOGIC_VECTOR(3 downto 0);
      zero:              out STD_LOGIC;
      pc:                inout STD_LOGIC_VECTOR((width-1) downto 0);
      instr:             in  STD_LOGIC_VECTOR((width-1) downto 0);
      aluout, writedata: inout STD_LOGIC_VECTOR((width-1) downto 0);
      readdata:          in  STD_LOGIC_VECTOR((width-1) downto 0));
end;

architecture struct of dataPath is

    component alu generic(width:integer);
    port(a, b:  in STD_LOGIC_VECTOR((width-1) downto 0);
          alucontrol: in  STD_LOGIC_VECTOR(3 downto 0);
          result:     inout STD_LOGIC_VECTOR((width-1) downto 0);
          zero:       out STD_LOGIC);
end component;

 component dataRegFile generic(width:integer);
    port(clk:   in STD_LOGIC;
        we:     in STD_LOGIC;--write enable bit
        ar,br,wr: in STD_LOGIC_VECTOR(5 downto 0);--register addresses
        wd:    in STD_LOGIC_VECTOR(31 downto 0);--data write
        ad,bd:   out STD_LOGIC_VECTOR(31 downto 0)); --register values
    end component;
        
   -- The datapath needs an adder component for the program counter  etc. 
    component adder generic(width: integer);
    port(a, b: in  STD_LOGIC_VECTOR((width-1) downto 0);
         y:    out STD_LOGIC_VECTOR((width-1) downto 0));
    end component;
    
      -- The datapath needs a sign extender component
    component signExtender generic( width: integer );
      port(a: in  STD_LOGIC_VECTOR((width/2)-1 downto 0);
           y: out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    
      -- The datapath needs a flip-flop register component for program counter etc.
    component flipFlop generic(width: integer);
      port(clk, reset: in  STD_LOGIC;
                    d: in  STD_LOGIC_VECTOR((width-1) downto 0);
                    q: out STD_LOGIC_VECTOR((width-1) downto 0));
    end component;
    
      -- The datapath needs a mux2 component for routing data
    component mux2 generic(width: integer);
      port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
           s:      in  STD_LOGIC;
           y:      out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    
    
begin


end Behavioral;
