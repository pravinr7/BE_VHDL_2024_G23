LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY top_level_anemometre IS 
    PORT
    (
        clk_50M : IN STD_LOGIC;
        in_freq_anemometre : IN STD_LOGIC;
        start_stop : IN STD_LOGIC;
        raz_n : IN STD_LOGIC;
        continu : IN STD_LOGIC;
        data_valid : OUT STD_LOGIC;
        data_anemometre : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END top_level_anemometre;

ARCHITECTURE top_level OF top_level_anemometre IS

    -- Déclarations des composants
    COMPONENT div_1hz
        PORT (
            clk_50M : IN STD_LOGIC;
            raz_n : IN STD_LOGIC;
            led : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT bloc_compteur
        PORT (
            clk_1Hz : IN STD_LOGIC;
            raz_n : IN STD_LOGIC;
            in_freq_anemometre : IN STD_LOGIC;
            counter_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT bloc_choix_mode
        PORT (
            clk : IN STD_LOGIC;
            raz_n : IN STD_LOGIC;
            start_stop : IN STD_LOGIC;
            continu : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            data_valid : OUT STD_LOGIC;
            data_anem : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Déclarations des signaux internes
    SIGNAL clk_1Hz : STD_LOGIC;
    SIGNAL counter_data : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    -- Instance du diviseur d'horloge (div_1hz)
    div_1hz_inst : div_1hz
        PORT MAP (
            clk_50M => clk_50M,
            raz_n => raz_n,
            led => clk_1Hz
        );

    -- Instance du compteur (bloc_compteur)
    bloc_compteur_inst : bloc_compteur
        PORT MAP (
            clk_1Hz => clk_1Hz,
            raz_n => raz_n,
            in_freq_anemometre => in_freq_anemometre,
            counter_out => counter_data,
            leds => OPEN -- Non utilisé
        );

    -- Instance du choix de mode (bloc_choix_mode)
    bloc_choix_mode_inst : bloc_choix_mode
        PORT MAP (
            clk => clk_1Hz,
            raz_n => raz_n,
            start_stop => start_stop,
            continu => continu,
            data_in => counter_data,
            data_valid => data_valid,
            data_anem => data_anemometre
        );

END top_level;
