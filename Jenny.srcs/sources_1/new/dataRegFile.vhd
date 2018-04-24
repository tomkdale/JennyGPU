---------------------------------------------------------------------
-- Three-port register file
---------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity dataRegfile is
  port(clk:        in  STD_LOGIC;
       we:         in  STD_LOGIC;
       ar, br, wr: in  STD_LOGIC_VECTOR(5  downto 0);
       wd:         in  STD_LOGIC_VECTOR(31 downto 0);
       ad, bd:     out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of dataRegfile is
  type ramtype is array (64 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  signal mem: ramtype;
begin
  -- Write new register file data
  process(clk) begin
    if rising_edge(clk) then
		if we = '1' then
			mem(to_integer(unsigned(wr))) <= wd;
		end if;
    end if;
  end process;

  -- Read mem from two separate ports 1 and 2
  -- Addresses are in ra1 and ra2
  process(ar,br, mem) begin
    if (to_integer(unsigned(ar)) = 0) then
		ad <= (others => '0'); -- register 0 holds 0
    else
		ad <= mem(to_integer(unsigned(ar)));
    end if;

    if (to_integer(unsigned(br)) = 0) then
		bd <= (others => '0'); -- register 0 holds 0
    else
		bd <= mem(to_integer(unsigned(br)));
    end if;
  end process;
end;
