library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level_anemo is
    Port (
        clk_50M            : in STD_LOGIC;  -- Horloge d'entrée de 50 MHz
        in_freq_anemometre : in STD_LOGIC;  -- Signal de fréquence de l'anémomètre
        start_stop         : in STD_LOGIC;  -- Signal de contrôle start/stop
        raz_n              : in STD_LOGIC;  -- Signal de reset asynchrone
        continu            : in STD_LOGIC;  -- Mode de fonctionnement (0, 1, 2)
        data_valid         : out STD_LOGIC;  -- Indicateur de validité des données de l'anémomètre
        data_anemometre    : out STD_LOGIC_VECTOR(7 downto 0)  -- Valeur des données de l'anémomètre
    );
end top_level_anemo;

architecture Behavioral of top_level_anemo is

    -- Signaux internes pour interconnecter les blocs
    signal clk_1Hz           : STD_LOGIC;
    signal counter_out       : STD_LOGIC_VECTOR(7 downto 0);
    signal led               : STD_LOGIC;
    signal data_from_counter : STD_LOGIC_VECTOR(7 downto 0);

    -- Instanciation du bloc div_1hz
    component div_1hz
        Port (
            clk_50M : in STD_LOGIC;
            raz_n   : in STD_LOGIC;
            led     : out STD_LOGIC
        );
    end component;

    -- Instanciation du bloc compteur
    component bloc_compteur
        Port (
            clk_1Hz            : in STD_LOGIC;
            raz_n              : in STD_LOGIC;
            in_freq_anemometre : in STD_LOGIC;
            counter_out        : out STD_LOGIC_VECTOR(7 downto 0);
            leds               : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Instanciation du bloc choix_mode
    component bloc_choix_mode
        Port (
            clk        : in STD_LOGIC;
            raz_n      : in STD_LOGIC;
            start_stop : in STD_LOGIC;
            continu    : in STD_LOGIC;
            data_in    : in STD_LOGIC_VECTOR(7 downto 0);
            data_valid : out STD_LOGIC;
            data_anem  : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin

    -- Instanciation du bloc div_1hz
    div_1hz_inst : div_1hz
        Port Map (
            clk_50M => clk_50M,
            raz_n   => raz_n,
            led     => clk_1Hz  -- Signal d'horloge 1Hz de sortie
        );

    -- Instanciation du bloc compteur
    bloc_compteur_inst : bloc_compteur
        Port Map (
            clk_1Hz            => clk_1Hz,
            raz_n              => raz_n,
            in_freq_anemometre => in_freq_anemometre,
            counter_out        => counter_out,
            leds               => data_from_counter
        );

    -- Instanciation du bloc choix_mode
    bloc_choix_mode_inst : bloc_choix_mode
        Port Map (
            clk        => clk_1Hz,
            raz_n      => raz_n,
            start_stop => start_stop,
            continu    => continu,
            data_in    => counter_out,
            data_valid => data_valid,
            data_anem  => data_anemometre
        );

end Behavioral;
