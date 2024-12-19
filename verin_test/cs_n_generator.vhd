library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cs_n_generator is
    port(
        clk_1mhz : in std_logic;
        cs_n : out std_logic
    );
end cs_n_generator;

architecture arc of cs_n_generator is
    -- Utilisation d'un signal pour le compteur, pour qu'il garde son état entre les cycles d'horloge
    signal cpt : integer range 0 to 99999 := 0; -- Initialisation du compteur à 0
begin

    process(clk_1mhz)
    begin
        -- Vérification du front montant de l'horloge
        if rising_edge(clk_1mhz) then
            -- Incrémentation du compteur
            if cpt < 99999 then
                cpt <= cpt + 1;  -- Incrémentation du compteur
                cs_n <= '0';  -- Le signal cs_n reste '0'
            else
                -- Une fois le compteur arrivé à 99999, on réinitialise et active cs_n
                cs_n <= '1';  -- Activation du signal cs_n
                cpt <= 0;     -- Réinitialisation du compteur à 0
            end if;
        end if;
    end process;

end arc;
