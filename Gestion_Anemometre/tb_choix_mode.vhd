library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_choix_mode is
end tb_choix_mode;

architecture Behavioral of tb_choix_mode is

    -- Composant à tester
    component bloc_choix_mode
        Port (
            clk           : in  std_logic;
            continu       : in  std_logic;
            start_stop    : in  std_logic;
            internal_reset: in  std_logic;
            data_in       : in  std_logic_vector (7 downto 0);
            data_valid    : out std_logic;
            data_anem     : out std_logic_vector (7 downto 0)
        );
    end component;

    -- Signaux pour interconnecter le composant et le testbench
    signal clk           : std_logic := '0';
    signal continu       : std_logic := '1';  -- Bouton logique inversée
    signal start_stop    : std_logic := '1';  -- Bouton logique inversée
    signal internal_reset: std_logic := '1';  -- Signal de reset
    signal data_in       : std_logic_vector(7 downto 0) := "00010100";  -- Constante à 20 en binaire
    signal data_valid    : std_logic;
    signal data_anem     : std_logic_vector(7 downto 0);

    -- Constante pour la période d'horloge (1 Hz)
    constant clk_period_1Hz : time := 1 sec;

begin

    -- Instanciation du composant
    uut: bloc_choix_mode
        Port map (
            clk           => clk,
            continu       => continu,
            start_stop    => start_stop,
            internal_reset=> internal_reset,
            data_in       => data_in,
            data_valid    => data_valid,
            data_anem     => data_anem
        );

    -- Génération de l'horloge à 1 Hz
    clk_process : process
    begin
        while true loop
            clk <= '1';
            wait for clk_period_1Hz / 2;
            clk <= '0';
            wait for clk_period_1Hz / 2;
        end loop;
    end process;

    -- Stimulus pour les boutons et le reset
    stim_process: process
    begin
        -- Attente avant le début des stimulations
        --wait for 200 ms;
        
        -- Phase 1 : Reset actif, rien ne doit se passer
        internal_reset <= '0';
        wait for 2 * clk_period_1Hz;
        internal_reset <= '1';  -- Désactivation du reset

        -- Phase 2 : Mode continu (bouton appuyé)
        continu <= '0';  -- Le bouton est appuyé (logique inversée)
        wait for 4 * clk_period_1Hz;
		  continu <= '1';

        -- Phase 3 : Mode start/stop (bouton start appuyé)
		  --wait for 4 * clk_period_1Hz;
        continu <= '1';  -- Désactivation du mode continu (logique inversée)
        start_stop <= '0';  -- Bouton appuyé (logique inversée)
        wait for 4 * clk_period_1Hz;

        -- Phase 4 : Stop (bouton start relâché)
		  wait for 4 * clk_period_1Hz;
        start_stop <= '1';  -- Bouton relâché (logique inversée)
        wait for 4 * clk_period_1Hz;

        -- Fin de la simulation
        wait;
    end process;

end Behavioral;
