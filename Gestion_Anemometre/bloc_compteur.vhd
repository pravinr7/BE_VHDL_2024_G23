library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Utiliser cette bibliothèque pour les opérations numériques
--use IEEE.STD_LOGIC_ARITH.ALL;


entity bloc_compteur is
    Port (
        clk_1Hz           : in STD_LOGIC;  -- Signal d'horloge à 1 Hz (1 seconde)
        raz_n             : in STD_LOGIC;  -- Reset asynchrone pour réinitialiser le compteur
        in_freq_anemometre: in STD_LOGIC;  -- Entrée pour la fréquence de l'anémomètre (variable)
        leds              : out STD_LOGIC_VECTOR (7 downto 0);  -- LEDs pour afficher le compteur (0 à 255)
		counter_out       : out STD_LOGIC_VECTOR (7 downto 0) -- pour stocker la valeur de la frequence
    );
end bloc_compteur;

architecture Behavioral of bloc_compteur is

    signal count       		: STD_LOGIC_VECTOR (7 downto 0) := "00000000";  -- Compteur pour le nombre de fronts montants de in_frq_anemometre
	 signal dernier_count	: STD_LOGIC_VECTOR (7 downto 0) := "00000000";
	 
	 
	 
begin

    process(clk_1Hz, raz_n,in_freq_anemometre)
    begin
        if raz_n = '0' then
			-- Réinitialiser compteur
            
				count <= (others => '0'); 
            dernier_count <= (others => '0');  
				
               
        elsif rising_edge( in_freq_anemometre) then
               
               
				if clk_1Hz ='1' then
				
					count <= std_logic_vector(unsigned(count) + 1);  -- Incrémenter le compteur sur un front montant
					
				elsif clk_1Hz ='0' then
					if unsigned(count) > 0 then
                    dernier_count <= count;
                end if;
					
					count <= (others => '0');   -- Réinitialiser le compteur de fronts
					 
				end if;
			end if;
         
          leds <= std_logic_vector(shift_left(unsigned(count), 1));
    end process;

	 counter_out <= std_logic_vector(shift_left(unsigned(dernier_count), 1));
	 
end Behavioral;