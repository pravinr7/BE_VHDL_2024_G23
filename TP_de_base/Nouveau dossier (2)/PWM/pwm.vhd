library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm is
    Port (
        clk        : in  STD_LOGIC;               -- Horloge
        reset_n    : in  STD_LOGIC;               -- Reset asynchrone actif bas
        duty       : in  STD_LOGIC_VECTOR (7 downto 0); -- Rapport cyclique (8 bits)
        freq_div    : in  STD_LOGIC_VECTOR (7 downto 0); -- Valeur de division pour la fr�quence PWM
        pwm_out    : out STD_LOGIC                -- Sortie PWM
    );
end pwm;

architecture Behavioral of pwm is
    -- D�claration des signaux pour les compteurs
    signal counter     : STD_LOGIC_VECTOR (7downto 0) := (others => '0');
    signal pwm_counter : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin

    -- Processus pour g�n�rer le compteur libre (pour la fr�quence du PWM)
    process (clk, reset_n)
    begin
        -- Gestion du reset asynchrone
        if reset_n = '1' then
            counter <= (others => '0');        -- Remise � z�ro du compteur
            pwm_counter <= (others => '0');    -- Remise � z�ro du compteur PWM
        elsif rising_edge(clk) then
            -- Incr�mentation du compteur pour la fr�quence PWM
            if counter = freq_div then
                counter <= (others => '0');   -- R�initialiser le compteur
                -- Incr�menter le compteur de PWM
                pwm_counter <= pwm_counter + 1;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Comparateur pour g�n�rer la sortie PWM
    process (pwm_counter, duty)
    begin
        if pwm_counter < duty then
            pwm_out <= '1';  -- Si le compteur PWM est inf�rieur � duty, pwm_out est haut
        else
            pwm_out <= '0';  -- Sinon, pwm_out est bas
        end if;
    end process;

end Behavioral;