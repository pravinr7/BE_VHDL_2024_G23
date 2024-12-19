library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        freqIn     : in  integer := 2000;          -- Fréquence PWM
        dutyIn     : in  integer := 1000;          -- Duty cycle (en %)
        bouton_g   : in  std_logic;        -- Bouton gauche
        bouton_d   : in  std_logic;        -- Bouton droit
        sens       : out std_logic;        -- Direction
        pwm_out    : out std_logic         -- Signal PWM
    );
end pwm;

architecture Behavioral of pwm is
    signal triangle : integer := 4000;       -- Signal triangulaire
    signal up       : boolean := true;    -- Direction du signal triangulaire
    signal sens_reg : std_logic := '0';   -- État de la direction
    signal enable   : std_logic := '0';   -- Indique si le moteur est actif
begin
    -- Génération du signal triangulaire
    process (clk)
    begin
        if reset = '0' then
            triangle <= 0;
            up <= true;
        elsif rising_edge(clk) then
            if enable = '1' then -- Triangle actif uniquement si le moteur est actif
                if up then
                    if triangle < freqIn then
                        triangle <= triangle + 1;
                    else
                        up <= false;
                    end if;
                else
                    if triangle > 0 then
                        triangle <= triangle - 1;
                    else
                        up <= true;
                    end if;
                end if;
            else
                triangle <= 0; -- Réinitialisation si mode veille
            end if;
        end if;
    end process;

    -- Génération du signal PWM
    pwm_out <= '1' when (enable = '1' and triangle < (freqIn * dutyIn) / 100) else '0';

    -- Gestion des boutons et mode veille
    process (clk)
    begin
        if reset = '0' then
            sens_reg <= '0';
            enable <= '0'; -- Mode veille par défaut au reset
        elsif rising_edge(clk) then
            if bouton_g = '0' then
                sens_reg <= '0'; -- Gauche
                enable <= '1';   -- Activer le moteur
            elsif bouton_d = '0' then
                sens_reg <= '1'; -- Droite
                enable <= '1';   -- Activer le moteur
            else
                enable <= '0';   -- Désactiver le moteur si aucun bouton n'est pressé
            end if;
        end if;
    end process;

    -- Sortie de la direction
    sens <= sens_reg;

end Behavioral;
