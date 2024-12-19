library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;

entity div_1hz is
    port (     clk_50M        : in std_logic;
               raz_n        	: in std_logic ;
               --clk_1Hz    	: out std_logic
					led				: out std_logic
          );
end div_1hz;

Architecture behavorial of div_1hz is

signal freq : std_logic;

begin

process(clk_50M, raz_n)
variable cpt    : integer;

begin
    if raz_n = '0' then
        cpt := 0;
    elsif rising_edge(clk_50M) then
        if (cpt=25000000-1) then
        cpt := 0;
        freq <= not freq;
        else
        cpt := cpt+1;
        end if;
    end if;
    --clk_1Hz<= freq;
	 led <= freq;
end process;

end behavorial;