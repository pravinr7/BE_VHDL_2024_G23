LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY test_bench IS
END test_bench;

ARCHITECTURE behavior OF test_bench IS
    -- Signaux pour l'entité à tester
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL chipselect : STD_LOGIC := '0';
    SIGNAL reset_n : STD_LOGIC := '1';
    SIGNAL write_n : STD_LOGIC := '1';
    SIGNAL writedata : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL readdata : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL address : STD_LOGIC := '0';
    
    SIGNAL in_freq_anemometre : STD_LOGIC := '0';
    SIGNAL data_anemometre : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Instanciation du module à tester
    COMPONENT avalon_anemo
        PORT (
            clk : IN STD_LOGIC;
            chipselect : IN STD_LOGIC;
            reset_n : IN STD_LOGIC;
            write_n : IN STD_LOGIC;
            writedata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            readdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            address : IN STD_LOGIC;
            in_freq_anemometre : IN STD_LOGIC;
            data_anemometre : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    -- Instanciation de l'entité avalon_anemo
    uut: avalon_anemo
        PORT MAP (
            clk => clk,
            chipselect => chipselect,
            reset_n => reset_n,
            write_n => write_n,
            writedata => writedata,
            readdata => readdata,
            address => address,
            in_freq_anemometre => in_freq_anemometre,
            data_anemometre => data_anemometre
        );

    -- Génération de l'horloge de 50 MHz
    clk_process: PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 10 ns;  -- période de 20 ns (50 MHz)
        clk <= '1';
        WAIT FOR 10 ns;
    END PROCESS;

    -- Processus de stimulation pour tester l'écriture et la lecture
    stim_proc: PROCESS
    BEGIN
        -- Réinitialisation
        reset_n <= '0';
        WAIT FOR 20 ns;
        reset_n <= '1';

        -- Test d'écriture dans le module
        chipselect <= '1';
        write_n <= '0';  -- Activer l'écriture
        writedata <= "0000000000000001";  -- Valeur d'écriture
        address <= '0';  -- Adresse de la commande de contrôle
        WAIT FOR 20 ns;

        -- Vérification des changements d'état
        chipselect <= '0';
        write_n <= '1';
        WAIT FOR 20 ns;

        -- Test de lecture à partir de l'adresse spécifiée
        address <= '1';  -- Adresse de lecture
        chipselect <= '1';
        WAIT FOR 20 ns;

        -- Test d'entrée de fréquence
        in_freq_anemometre <= '1';
        WAIT FOR 40 ns;
        in_freq_anemometre <= '0';
        WAIT FOR 40 ns;

        -- Fin de la simulation
        WAIT;
    END PROCESS;
END behavior;
