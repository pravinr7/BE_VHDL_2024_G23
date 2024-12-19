library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;

entity TP1_blinkled is
	port ( 	clk		: in std_logic;
				rst		: in std_logic;
				led_out	: out std_logic
			);
end TP1_blinkled;

Architecture behavorial of TP1_blinkled is

signal freq		: std_logic;

begin

process(clk, rst)
variable cpt	: integer;

begin
	if (rst='1') then
		cpt := 0;
	elsif rising_edge(clk) then
		if (cpt=25000000-1) then
		cpt := 0;
		freq <= not freq;
		else
		cpt := cpt+1;
		end if;
	end if;
	led_out<= freq;
end process;

end behavorial;