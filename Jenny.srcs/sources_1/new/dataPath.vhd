library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
-- dataPath Unit for the Jenny GPU

entity dataPath is
 port(clk,reset:    in  STD_LOGIC;
          instr:    in  STD_LOGIC_VECTOR(31 downto 0);
          addr:     in  STD_LOGIC_VECTOR(15 downto 0);
          addrnext: out STD_LOGIC_VECTOR(15 downto 0);
          -- Control unit signals
          CUbranch, CUbranchDataWrite, CUreg0enable, CUreg1enable, CUreg2enable, CUreg3enable: in STD_LOGIC;
          CUimmCalc, CUbranchZero, CUload, CUdataMemWrite: in STD_LOGIC;
          rot:        in STD_LOGIC_VECTOR(1 downto 0);
          alucontrol: in STD_LOGIC_VECTOR(3 downto 0);
          point1x,point2x,point3x,point4x,point5x,point6x,point7x,point8x: out STD_LOGIC_VECTOR(31 downto 0);
          point1y,point2y,point3y,point4y,point5y,point6y,point7y,point8y: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture struct of dataPath is
-- The datapath needs n ALUs to parallelize data processing
 component alu
    port(a, b:       in STD_LOGIC_VECTOR(31 downto 0);
         alucontrol: in  STD_LOGIC_VECTOR(3 downto 0);
         result:     inout STD_LOGIC_VECTOR(31 downto 0);
         zero:       out STD_LOGIC);
end component;

 -- The datapath needs n register files for parallelized data accessing
 component dataRegFile
    port(clk:      in  STD_LOGIC;
         we:       in  STD_LOGIC; -- Write enable bit
         ar,br,wr: in  STD_LOGIC_VECTOR(5  downto 0);  -- Register addresses
         wd:       in  STD_LOGIC_VECTOR(31 downto 0);  -- Data write
         ad, bd:   out STD_LOGIC_VECTOR(31 downto 0)); -- Register values
    end component;

 -- The datapath needs a register file to store saved branch locations and other scalar data
 component branchFile
    port(clk: in  STD_LOGIC;
         we:  in  STD_LOGIC;
         wr:  in  STD_LOGIC_VECTOR(5  downto 0);
         wd:  in  STD_LOGIC_VECTOR(15 downto 0);
         ad:  out STD_LOGIC_VECTOR(15 downto 0));
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

   

      -- The datapath needs a mux2 component for routing data. needs variable size
    component mux2 generic(width: integer);
      port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
           s:      in  STD_LOGIC;
           y:      out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;

    component rotator -- Rotator moves the a registers between ALUs
        port(a0, a1, a2, a3:    in  STD_LOGIC_VECTOR(31 downto 0);
            rot:                in  STD_LOGIC_VECTOR(1  downto 0);
            a0n, a1n, a2n, a3n: out STD_LOGIC_VECTOR(31 downto 0)); -- New a values (values after rotation)
    end component;
    component dmem is -- Data memory
      port(clk:      in  STD_LOGIC;
           load:     in  STD_LOGIC;
           save:     in  STD_LOGIC;
           dat:      in  STD_LOGIC_VECTOR(127 downto 0);
           dataaddr: in  STD_LOGIC_VECTOR(15  downto 0);
           rd:       out STD_LOGIC_VECTOR(127 downto 0);
           point1x,point2x,point3x,point4x,point5x,point6x,point7x,point8x: out STD_LOGIC_VECTOR(31 downto 0);
           point1y,point2y,point3y,point4y,point5y,point6y,point7y,point8y: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    -- Data path signals
    signal doJump: STD_LOGIC;
    signal pcplus, pcjump, pcbranch, pcnextbranch, immData,middleaddr: STD_LOGIC_VECTOR(15 downto 0);
    signal one: STD_LOGIC_VECTOR(15 downto 0);
    signal const_zero: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ar, br, wr: STD_LOGIC_VECTOR(5 downto 0);
    signal reg0WD, reg1WD, reg2WD, reg3WD: STD_LOGIC_VECTOR(31 downto 0);
    signal a0, a1, a2, a3, a0n, a1n, a2n, a3n, b0, b1, b2, b3, b0n, b1n, b2n, b3n, immData32: STD_LOGIC_VECTOR(31 downto 0);
    signal aluResult0, aluResult1, aluResult2, aluResult3: STD_LOGIC_VECTOR(31 downto 0);
    signal z0, z1, z2, z3,z0n,z1n,z2n,z3n: STD_LOGIC; --zero results from each alu
    signal loadMem: STD_LOGIC_VECTOR(127 downto 0);
    signal saveMem: STD_LOGIC_VECTOR(127 downto 0);
    signal branchIncrement: STD_LOGIC_VECTOR(15 downto 0);

begin -- Data path buses and hardware
  
    one     <= const_zero(12 downto 1) & X"1";
    pcjump  <= instr(15 downto 0);
    ar <= instr(21 downto 16) when CUimmCalc = '1' else
     instr(21 downto 16) when CUdatamemwrite = '1' else
      instr(15  downto 10);
    br      <= "000000" when CUimmCalc ='1' else instr(9 downto 4);
    wr      <= instr(21 downto 16);
    immData <= instr(15 downto 0);
    
    immSignExtend:     signExtender generic map(32) port map(a => immData,y => immData32);
    pcIncrement:       adder        generic map(16) port map(a => addr, b => one, y => pcplus);
    branchNobranchmux: mux2         generic map(16) port map(d0 => pcbranch, d1 => middleaddr, s => cubranchzero, y => addrnext);
    middlemux:         mux2         generic map(16) port map(d0 =>pcplus, d1 =>pcnextbranch, s =>dojump, y=>middleaddr);
    jumpBranchmux:     mux2         generic map(16) port map(d0 => pcplus, d1 => pcjump, s => CUbranch, y => pcbranch);
    calcBranch:        adder        generic map(16) port map (a=>branchIncrement,b=>addr,y=>pcnextbranch);
    
    branchRegFile:     branchFile   port    map(clk => clk, we => CUbranchDataWrite, wr => wr, wd => immData, ad => branchIncrement);

    rf0:     dataRegFile port    map(clk => clk, we => CUreg0enable, ar => ar, br => br, wr=> wr, wd => reg0WD, ad => a0, bd => b0);
    rf1:     dataRegFile port    map(clk => clk, we => CUreg1enable, ar => ar, br => br, wr=> wr, wd => reg1WD, ad => a1, bd => b1);
    rf2:     dataRegFile port    map(clk => clk, we => CUreg2enable, ar => ar, br => br, wr=> wr, wd => reg2WD, ad => a2, bd => b2);
    rf3:     dataRegFile port    map(clk => clk, we => CUreg3enable, ar => ar, br => br, wr=> wr, wd => reg3WD, ad => a3, bd => b3);
    rot1:    rotator     port    map(a0 => a0, a1 => a1, a2 => a2, a3 => a3, rot => rot, a0n => a0n, a1n => a1n, a2n => a2n, a3n => a3n);
    immMux0: mux2        generic map(32) port map(d0 => b0, d1 => immData32, s => CUimmCalc, y => b0n);
    immMux1: mux2        generic map(32) port map(d0 => b1, d1 => immData32, s => CUimmCalc, y => b1n);
    immMux2: mux2        generic map(32) port map(d0 => b2, d1 => immData32, s => CUimmCalc, y => b2n);
    immMux3: mux2        generic map(32) port map(d0 => b3, d1 => immData32, s => CUimmCalc, y => b3n);
    alu0:    alu         port    map(a => a0n, b => b0n, alucontrol => aluControl, result => aluresult0, zero => z0);
    alu1:    alu         port    map(a => a1n, b => b1n, alucontrol => aluControl, result => aluresult1, zero => z1);
    alu2:    alu         port    map(a => a2n, b => b2n, alucontrol => aluControl, result => aluresult2, zero => z2);
    alu3:    alu         port    map(a => a3n, b => b3n, alucontrol => aluControl, result => aluresult3, zero => z3);
    
    z0n <= '1' when CUreg0enable ='0' else z0;--branch not equal command will only consider those enabled alu results
    z1n <= '1' when CUreg1enable ='0' else z1;
    z2n <= '1' when CUreg2enable ='0' else z2;
    z3n <= '1' when CUreg3enable ='0' else z3;
    doJump <= z0n and z1n and z2n and z3n and CUbranchZero;
    
    wd0mux: mux2 generic map(32) port map(d0 => aluresult0, d1 => loadMem(31  downto 0), s => CUload, y => reg0WD);
    wd1mux: mux2 generic map(32) port map(d0 => aluresult1, d1 => loadMem(63  downto 32), s => CUload, y => reg1WD);
    wd2mux: mux2 generic map(32) port map(d0 => aluresult2, d1 => loadMem(95  downto 64), s => CUload, y => reg2WD);
    wd3mux: mux2 generic map(32) port map(d0 => aluresult3, d1 => loadMem(127 downto 96), s => CUload, y => reg3WD);

    saveMem <= aluresult0 & aluresult1 & aluresult2 & aluresult3;
    dataMemory: dmem port map(clk => clk, load => CUload, save => CUdatamemwrite, dat => saveMem, dataaddr => immData, rd => loadMem,
    point1x => point1x, point2x => point2x, point3x => point3x, point4x => point4x, point5x => point5x, point6x => point6x, point7x => point7x, point8x => point8x,
    point1y => point1y, point2y => point2y, point3y => point3y, point4y => point4y, point5y => point5y, point6y => point6y, point7y => point7y, point8y => point8y);

end struct;
