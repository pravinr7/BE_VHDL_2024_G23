library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pm is
    Port ( clk_50mhz: in std_logic;
           reset_n  : in  STD_LOGIC;
           duty     : in  STD_LOGIC_VECTOR (7 downto 0); -- N = 8 bits
           Nfreq    : in std_logic_vector(7 downto 0);
           rst 		: in std_logic;
           pwm_out  : out STD_LOGIC);
end pm;

architecture Behavioral of pm is
    signal counter : STD_LOGIC_VECTOR (7 downto 0); -- Compteur N bits 
    -- constant duty_value : STD_LOGIC_VECTOR (7 downto 0) := "10000000"; -- 50% de rapport cyclique
	signal compteur_f :STD_LOGIC_VECTOR (7 downto 0);
	signal clk : STD_LOGIC;
begin
	process(clk_50mhz,rst)
	variable clk_1s :std_logic ;
	begin 
			if(rst ='1')then 
			clk_1s:='0';
			compteur_f <= (others=> '0');
	elsif(rising_edge(clk_50mhz))then 
			compteur_f <= compteur_f +1;
			if(compteur_f=Nfreq)then 
			clk_1s:=not clk_1s;
			compteur_f <=(others=> '0');
			end if;
			end if;
					clk<=clk_1s;
		end process;

--    --process (clk, reset_n)
--    begin
--        if (reset_n = '1') then
--            counter <= (others => '0'); -- Réinitialisation asynchrone
--        elsif (rising_edge(clk)) then
--            counter <= counter + 1; -- Incrémentation du compteur
--        end if;
--    end process;

    process (compteur_f, duty)
    begin
        if(compteur_f < duty) then
            pwm_out <= '1'; -- Génération de la PWM
        else
            pwm_out <= '0';
        end if;
    end process;

end Behavioral;