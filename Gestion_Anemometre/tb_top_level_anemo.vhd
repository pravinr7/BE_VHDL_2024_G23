library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_top_level_anemo is
end tb_top_level_anemo;

architecture test of tb_top_level_anemo is

    -- Signaux de test pour le module top_level_anemo
    signal clk_50M            : STD_LOGIC := '0';  -- Horloge d'entrée de 50 MHz
    signal in_freq_anemometre : STD_LOGIC := '0';  -- Signal de fréquence de l'anémomètre
    signal start_stop         : STD_LOGIC := '1';  -- En mode continu
    signal raz_n              : STD_LOGIC := '1';  -- Reset asynchrone (pas testé ici)
    signal continu            : STD_LOGIC := '1';  -- Mode continu
    signal data_valid         : STD_LOGIC;
    signal data_anemometre    : STD_LOGIC_VECTOR(7 downto 0);

    -- Signal de temporisation pour la simulation
    constant clk_period : time := 20 ns;  -- Période de l'horloge de 50 MHz

    -- Instanciation du module top_level_anemo
    component top_level_anemo
        Port (
            clk_50M            : in STD_LOGIC;
            in_freq_anemometre : in STD_LOGIC;
            start_stop         : in STD_LOGIC;
            raz_n              : in STD_LOGIC;
            continu            : in STD_LOGIC;
            data_valid         : out STD_LOGIC;
            data_anemometre    : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin

    -- Instanciation de l'instance du module
    uut: top_level_anemo
        Port Map (
            clk_50M            => clk_50M,
            in_freq_anemometre => in_freq_anemometre,
            start_stop         => start_stop,
            raz_n              => raz_n,
            continu            => continu,
            data_valid         => data_valid,
            data_anemometre    => data_anemometre
        );

    -- Générateur de l'horloge de 50 MHz
    clk_process: process
    begin
        clk_50M <= '0';
        wait for clk_period / 2;
        clk_50M <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimuli pour tester le module
    stimulus_process: process
    begin
        -- Initialisation des signaux
        in_freq_anemometre <= '0';
        wait for 100 ns;

        -- Générer un signal de fréquence (exemple de signal simple)
        in_freq_anemometre <= '1';
        wait for 200 ns;
        in_freq_anemometre <= '0';
        wait for 100 ns;
        in_freq_anemometre <= '1';
        wait for 300 ns;
        in_freq_anemometre <= '0';
        wait for 100 ns;

        -- Maintien du test pendant un certain temps pour observer la sortie
        wait for 500 ns;

        -- Fin de la simulation
        assert false report "Test terminé" severity note;
        wait;
    end process;

    -- Vérification de la condition attendue : in_freq_anemometre doit correspondre à data_anemometre
    check_process: process
    begin
        wait for 100 ns;  -- Attendre un peu avant de commencer la vérification

        if (data_anemometre = "00000000") then
            report "Test échoué : data_anemometre est à 0" severity error;
        elsif (data_anemometre = std_logic_vector(to_unsigned(1, 8))) then
            report "Test réussi : data_anemometre correspond à in_freq_anemometre" severity note;
        else
            report "Test échoué : valeur inattendue pour data_anemometre" severity error;
        end if;

        wait;
    end process;

end test;
