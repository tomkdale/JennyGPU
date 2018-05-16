------------------------------------------------------------------------------
-- Instruction Memory
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity imem is -- instruction memory
    port(addr:  in  STD_LOGIC_VECTOR(15 downto 0);
         instr: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of imem is
    type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    
    -- Function to initialize the instruction memory from a data file
    impure function InitRamFromFile ( RamFileName : in string ) return RamType is
    variable ch:        character;
    variable index:     integer;
    variable result:    signed(31 downto 0);
    variable tmpResult: signed(63 downto 0);
    file     mem_file:  TEXT is in RamFileName;
    variable L:         line;
    variable RAM:       ramtype;
    begin
        -- Initialize memory from a file
        for i in 0 to 63 loop -- set all contents low
            RAM(i) := std_logic_vector(to_unsigned(0, 32));
        end loop;
        index := 0;
        while not endfile(mem_file) loop
            -- Read the next line from the file
            readline(mem_file, L);
            result := to_signed(0,32);
            for i in 1 to 8 loop
                -- Read character from the line just read
                read(L, ch);
                --  Convert character to a binary value from a hex value
                if '0' <= ch and ch <= '9' then
                    tmpResult := result*16 + character'pos(ch) - character'pos('0') ;
                    result := tmpResult(31 downto 0);
                elsif 'a' <= ch and ch <= 'f' then
                    tmpResult := result*16 + character'pos(ch) - character'pos('a')+10 ;
                    result := tmpResult(31 downto 0);
                else report "Format error on line " & integer'image(index)
                    severity error;
                end if;
            end loop;
            -- Set the width bit binary value in ram
            RAM(index) := std_logic_vector(result);
            index := index + 1;
        end loop;
        -- Return the array of instructions loaded in RAM
        return RAM;
    end function;
    
    -- Use the impure function to read RAM from a file and store in the FPGA's ram memory
    signal mem: ramtype := InitRamFromFile("vgasimple.dat");
    
    begin
    
    process (addr) is
    begin
        instr <= mem(to_integer(unsigned(addr)));
    end process;
     
end behave;
