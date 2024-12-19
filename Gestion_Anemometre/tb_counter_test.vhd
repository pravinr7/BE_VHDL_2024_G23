library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_counter_test is
end tb_counter_test;

architecture Behavioral of tb_counter_test is

    -- Composant à tester
    component counter_test
        Port (
            clk_1Hz           : in STD_LOGIC;
            raz_n             : in STD_LOGIC;
            in_freq_anemometre: in STD_LOGIC;
            leds              : out STD_LOGIC_VECTOR (8 downto 0);
            counter_out       : out STD_LOGIC_VECTOR (8 downto 0);
            count_up_out   : out STD_LOGIC_VECTOR (8 downto 0);  -- Ajout du signal count_up
            count_down_out : out STD_LOGIC_VECTOR (8 downto 0)   -- Ajout du signal count_down
        );
    end component;

    -- Signaux internes pour interconnecter le composant et le test bench
    signal clk_1Hz           : STD_LOGIC := '0';
    signal raz_n             : STD_LOGIC := '1';
    signal in_freq_anemometre: STD_LOGIC := '0';
    signal leds              : STD_LOGIC_VECTOR(8 downto 0);
    signal counter_out       : STD_LOGIC_VECTOR(8 downto 0);
    signal count_up_signal   : STD_LOGIC_VECTOR(8 downto 0);  -- Signal pour observer count_up
    signal count_down_signal : STD_LOGIC_VECTOR(8 downto 0);  -- Signal pour observer count_down

    -- Constante pour la période d'horloge (1 seconde pour clk_1Hz)
    constant clk_period_1Hz : time := 1 sec;

begin

    -- Instanciation du composant
    uut: counter_test
        Port map (
            clk_1Hz           => clk_1Hz,
            raz_n             => raz_n,
            in_freq_anemometre=> in_freq_anemometre,
            leds              => leds,
            counter_out       => counter_out,
            count_up_out   => count_up_signal,  -- Mapping de count_up
            count_down_out => count_down_signal -- Mapping de count_down
        );

    -- Processus de génération de l'horloge à 1 Hz
    clk_process : process
    begin
        while true loop
            clk_1Hz <= '1';
            wait for clk_period_1Hz / 2;
            clk_1Hz <= '0';
            wait for clk_period_1Hz / 2;
        end loop;
    end process clk_process;

    -- Processus pour générer un signal carré à différentes fréquences
    stim_proc: process
        variable freq_period : time;
    begin
        -- Réinitialisation
--        raz_n <= '0';  -- Activer le reset
--        wait for 100 ms;  -- Attendre un moment
--        raz_n <= '1';  -- Désactiver le reset
--        wait for 100 ms;  -- Attendre encore pour observer la réinitialisation

        -- PHASE 1: Générer un signal carré à 11 Hz pendant 1000 ms (période complète de clk_1Hz)
        freq_period := 52.6315 ms;  -- 19 Hz (période impaire)
        wait until clk_1Hz = '1';  -- Attendre que clk_1Hz passe à '1'
        for i in 0 to (1000 ms / freq_period) - 1 loop  -- Durer pour 1000 ms (cycle complet de clk_1Hz)
            in_freq_anemometre <= '1';   -- Front montant
            wait for freq_period / 2;
            in_freq_anemometre <= '0';   -- Front descendant
            wait for freq_period / 2;
        end loop;

        -- PHASE 2: Générer un signal carré à 2 Hz pendant 1000 ms (période complète de clk_1Hz)
        freq_period := 500 ms;  -- 2 Hz
        wait until clk_1Hz = '1';  -- Attendre que clk_1Hz repasse à '1'
        for i in 0 to (1000 ms / freq_period) - 1 loop  -- Durer pour 1000 ms
            in_freq_anemometre <= '1';   -- Front montant
            wait for freq_period / 2;
            in_freq_anemometre <= '0';   -- Front descendant
            wait for freq_period / 2;
        end loop;

        -- PHASE 3: Générer un signal carré à 33 Hz pendant 1000 ms (période complète de clk_1Hz)
        freq_period := 30.30 ms;  -- 33 Hz (période impaire)
        wait until clk_1Hz = '1';  -- Attendre que clk_1Hz repasse à '1'
        for i in 0 to (1000 ms / freq_period) - 1 loop  -- Durer pour 1000 ms
            in_freq_anemometre <= '1';   -- Front montant
            wait for freq_period / 2;
            in_freq_anemometre <= '0';   -- Front descendant
            wait for freq_period / 2;
        end loop;

        -- PHASE 4: Générer un signal carré à 250 Hz pendant 1000 ms (période complète de clk_1Hz)
        freq_period := 4 ms;  -- 250 Hz
        wait until clk_1Hz = '1';  -- Attendre que clk_1Hz repasse à '1'
        for i in 0 to (1000 ms / freq_period) - 1 loop  -- Durer pour 1000 ms
            in_freq_anemometre <= '1';   -- Front montant
            wait for freq_period / 2;
            in_freq_anemometre <= '0';   -- Front descendant
            wait for freq_period / 2;
        end loop;

        -- Fin de la simulation
        --wait;
    end process stim_proc;

end Behavioral;
