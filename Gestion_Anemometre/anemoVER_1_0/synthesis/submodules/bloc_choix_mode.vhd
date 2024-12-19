library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity bloc_choix_mode is
port ( 	clk, raz_n, start_stop, continu 	: in std_logic;
		data_in 										: in std_logic_vector (7 downto 0);
		data_valid 									: out std_logic;
		data_anem									: out std_logic_vector (7 downto 0));
end bloc_choix_mode;

architecture bhv of bloc_choix_mode is

signal tmp  : std_logic_vector (7 downto 0);

begin
process(clk)

begin

if(clk'event and clk='1') then
	if continu = '0' then
		if raz_n = '0' then
			tmp <= "00000000";
			data_valid <= '0';
		else
			tmp <= data_in;
			data_valid <= '1';
		
		end if;
	else
		if start_stop = '0' then
		   tmp <= data_in;
			
			data_valid <= '1';
			
		else
			tmp <= "00000000";
			data_valid <= '0';
	
			
		end if;
	end if;
end if;

data_anem <= tmp;
end process;

end bhv;