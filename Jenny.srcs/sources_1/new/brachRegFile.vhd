---------------------------------------------------------------------
-- three-port register file
---------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity branchFile is
  port(clk: in  STD_LOGIC;
       we:  in  STD_LOGIC;
       ar:  in  STD_LOGIC_VECTOR(5  downto 0);
       wd:  in  STD_LOGIC_VECTOR(15 downto 0);
       ad:  out STD_LOGIC_VECTOR(15 downto 0));
end;

architecture behave of branchFile is

    type ramtype is array (64 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
    signal mem: ramtype;

    begin

    -- Saves branch data to register address
    process(clk) begin
        if rising_edge(clk) then
            if we = '1' then
                mem(to_integer(unsigned(ar))) <= wd;
            end if;
        end if;
    end process;
        
    -- Gets branch data from register address
    process(ar, mem) begin
        ad <= mem(to_integer( unsigned(ar)));
    end process;
end;
