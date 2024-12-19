library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_test is
    Port (
        clk_1Hz           : in STD_LOGIC;  -- Signal d'horloge à 1 Hz (1 seconde)
        raz_n             : in STD_LOGIC;  -- Reset asynchrone pour réinitialiser le compteur
        in_freq_anemometre: in STD_LOGIC;  -- Entrée pour la fréquence de l'anémomètre (variable)
        leds              : out STD_LOGIC_VECTOR (8 downto 0);  -- LEDs pour afficher le compteur (0 à 255)
        counter_out       : out STD_LOGIC_VECTOR (8 downto 0);  -- Pour stocker la valeur de la somme des compteurs
        count_up_out      : out STD_LOGIC_VECTOR (8 downto 0);  -- Compteur up exposé
        count_down_out    : out STD_LOGIC_VECTOR (8 downto 0)   -- Compteur down exposé
    );
end counter_test;

architecture Behavioral of counter_test is

    signal count_up      : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');  -- Compteur pour clk_1Hz = '1'
    signal count_down    : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');  -- Compteur pour clk_1Hz = '0'
    signal sum_count     : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');  -- Somme de count_up et count_down
    signal prev_clk_1Hz  : STD_LOGIC := '0';  -- Pour mémoriser l'état précédent de clk_1Hz

begin

    process(clk_1Hz, raz_n, in_freq_anemometre)
    begin
        if raz_n = '0' then
            -- Réinitialiser les compteurs
            count_up   <= (others => '0');
            count_down <= (others => '0');
            sum_count  <= (others => '0');
            prev_clk_1Hz <= '0';  -- Reset également la mémoire de l'état précédent
        elsif rising_edge(in_freq_anemometre) then
            if clk_1Hz = '1' then
                -- Incrémenter count_up si clk_1Hz = '1'
                count_up <= std_logic_vector(unsigned(count_up) + 1);
            elsif clk_1Hz = '0' then
                -- Incrémenter count_down si clk_1Hz = '0'
                count_down <= std_logic_vector(unsigned(count_down) + 1);
            end if;
				leds <= std_logic_vector(unsigned(count_up) + unsigned(count_down));
        end if;
        
        -- Calcul de la somme UNIQUEMENT lorsque clk_1Hz passe de '0' à '1'
        if (clk_1Hz = '1') and (prev_clk_1Hz = '0') then
            sum_count <= std_logic_vector(unsigned(count_up) + unsigned(count_down));
--					sum_count <= "000000011";
            -- Réinitialiser les compteurs après le calcul de la somme
            count_up <= (others => '0');
            count_down <= (others => '0');
				leds<= (others => '0');
				
        end if;

        -- Mémoriser l'état actuel de clk_1Hz pour le cycle suivant
        prev_clk_1Hz <= clk_1Hz;

        -- Afficher et stocker la somme qui reste jusqu'au prochain calcul
        --leds <= sum_count;  -- Afficher la somme sur les LEDs
        counter_out <= sum_count;  -- Stocker la somme dans counter_out

        -- Exposer les compteurs count_up et count_down à l'extérieur
        count_up_out <= count_up;
        count_down_out <= count_down;
		 
    end process;

end Behavioral;
