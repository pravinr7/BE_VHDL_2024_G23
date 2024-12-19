library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;


entity counter is
    Port (
        clk_1Hz           : in STD_LOGIC;  -- Signal d'horloge à 1 Hz (1 seconde)
        raz_n             : in STD_LOGIC;  -- Reset asynchrone pour réinitialiser le compteur
        in_freq_anemometre: in STD_LOGIC;  -- Entrée pour la fréquence de l'anémomètre (variable)
        leds              : out STD_LOGIC_VECTOR (7 downto 0)  -- LEDs pour afficher le compteur (0 à 255)
    );
end counter;

architecture Behavioral of counter is

    signal count1         : unsigned(7 downto 0) := (others => '0');  -- Compteur pour le nombre de fronts montants horloge
    signal count2         : unsigned(7 downto 0) := (others => '0');  -- Compteur pour le nombre de fronts montants anemometre
    
begin

    process(clk_1Hz, raz_n, in_freq_anemometre)
    begin
        if raz_n = '0' then
            -- Réinitialiser les 2 compteurs
            count1 <= (others => '0');
            count2 <= (others => '0');
            
        elsif clk_1Hz ='1' then
            if count1 = 2 then 
                count1 <= (others => '0');
                count2 <= (others => '0');
            
            else 
                count1 <= count1 + 1;
                if rising_edge(in_freq_anemometre) then
                    count2 <= count2 + 1;
                end if;
            end if;
        end if;
        
        leds <= std_logic_vector(count2);  -- Conversion d'unsigned en STD_LOGIC_VECTOR pour les LEDs
    
    end process;

end Behavioral;
