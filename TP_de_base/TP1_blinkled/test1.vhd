library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test1 is
    Port (
        clk_div : in std_logic;             -- Horloge divisée (ex : 1 Hz)
        raz_n : in std_logic;               -- Reset actif bas
        mode_continue : in std_logic;       -- 1 pour mode continu, 0 pour mode monocoup
        start : in std_logic;               -- Démarrer l'acquisition en mode monocoup
        compteur_val : out integer range 0 to 255 -- Valeur du compteur sur 8 bits (0 à 255)
    );
end test1;

architecture Behavioral of test1  is
    signal compteur_pulses : integer range 0 to 255 := 0;  -- Compteur interne
    signal acquisition_active : std_logic := '0';          -- Indicateur d'acquisition active

begin
    -- Processus qui gère le compteur selon le mode choisi
    process(clk_div, raz_n)
    begin
        if raz_n = '0' then                 -- Si le reset est actif
            compteur_pulses <= 0;           -- Réinitialiser le compteur à 0
            acquisition_active <= '0';       -- Désactiver l'acquisition
        elsif rising_edge(clk_div) then     -- Si front montant de l'horloge divisée
            if mode_continue = '1' then      -- Mode continu
                if compteur_pulses < 255 then  -- Limiter à 8 bits
                    compteur_pulses <= compteur_pulses + 1;  -- Incrémenter le compteur
                else
                    compteur_pulses <= 0;       -- Réinitialiser à 0 quand il atteint 255
                end if;
            elsif mode_continue = '0' then   -- Mode monocoup
                if start = '1' then           -- Si démarrer l'acquisition
                    acquisition_active <= '1'; -- Activer l'acquisition
                    if compteur_pulses < 255 then  -- Limiter à 8 bits
                        compteur_pulses <= compteur_pulses + 1;  -- Incrémenter le compteur
                    else
                        compteur_pulses <= 0;       -- Réinitialiser à 0 quand il atteint 255
                    end if;
                else
                    acquisition_active <= '0';      -- Désactiver l'acquisition si start est à 0
                end if;
            end if;
        end if;
    end process;

    -- Sortie du compteur
    compteur_val <= compteur_pulses;

end Behavioral;