library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity choix_mode is
    Port (
        clk_1Hz        : in STD_LOGIC;               -- Signal d'horloge à 1 Hz (1 seconde)
        raz_n          : in STD_LOGIC;               -- Reset asynchrone
        mode_continu   : in STD_LOGIC;               -- Bouton pour mode continu (1 = continu, 0 = monocoup)
        start_stop     : in STD_LOGIC;               -- Bouton pour start/stop acquisition en mode monocoup
        counter_out    : in STD_LOGIC_VECTOR(7 downto 0);  -- Données d'entrée du compteur de l'anémomètre
        data_valid     : out STD_LOGIC;              -- Signal indiquant que les données sont valides
        data_anemometre: out STD_LOGIC_VECTOR(7 downto 0)  -- Données de l'anémomètre en sortie
    );
end choix_mode;

architecture Behavioral of choix_mode is
    signal data_valid_reg : STD_LOGIC := '0';         -- Registre pour stocker l'état de data_valid
    signal data_anemometre_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');  -- Registre pour stocker les données anémomètre

begin

    process(clk_1Hz, raz_n)
    begin
        if raz_n = '0' then
            -- Reset les registres de sortie
            data_valid_reg      <= '0';
            data_anemometre_reg <= (others => '0');
        elsif rising_edge(clk_1Hz) then
            if mode_continu = '0' then
                -- Mode continu : rafraîchit les données toutes les secondes
                data_valid_reg      <= '1';  -- La donnée est toujours valide
                data_anemometre_reg <= counter_out;  -- On met à jour les données anémomètre chaque seconde
            else
                -- Mode monocoup
                if start_stop = '0' then
                    -- Démarrage de l'acquisition en monocoup
                    data_valid_reg      <= '1';
                    data_anemometre_reg <= counter_out;
                elsif start_stop = '1' then
                    -- Stop de l'acquisition, on remet data_valid à 0
                    data_valid_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Assignation des signaux de sortie
    data_valid      <= data_valid_reg;
    data_anemometre <= data_anemometre_reg;

end Behavioral;
