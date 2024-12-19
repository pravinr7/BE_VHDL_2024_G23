library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
        clk_50M        : in std_logic;              -- Horloge à 50 MHz
        raz_n          : in std_logic;              -- Reset asynchrone commun
        in_freq_anemometre : in std_logic;          -- Entrée fréquence anémomètre
        leds           : out std_logic_vector(8 downto 0);  -- LEDs pour le compteur
        counter_out    : out std_logic_vector(8 downto 0);  -- Sortie du compteur
        count_up_out   : out std_logic_vector(8 downto 0);  -- Sortie compteur up
        count_down_out : out std_logic_vector(8 downto 0)   -- Sortie compteur down
    );
end top_level;

architecture Behavioral of top_level is

    signal clk_1Hz_signal : std_logic;  -- Signal 1Hz issu de div_1Hz

begin

    -- Instance du diviseur de fréquence (div_1hz)
    div_1hz_inst : entity work.div_1hz
        port map (
            clk_50M => clk_50M,
            raz_n   => raz_n,
            --clk_1Hz => clk_1Hz_signal  -- Nous utilisons 'led' comme sortie du 1Hz
            led     => clk_1Hz_signal
        );

    -- Instance du compteur (counter_test)
    counter_test_inst : entity work.counter_test
        port map (
            clk_1Hz           => clk_1Hz_signal,        -- Connexion de la sortie de div_1hz
            raz_n             => raz_n,                 -- Reset commun
            in_freq_anemometre => in_freq_anemometre,    -- Entrée fréquence anémomètre
            leds              => leds,                  -- LEDs du compteur
            counter_out       => counter_out,           -- Sortie du compteur
            count_up_out      => count_up_out,          -- Sortie compteur up
            count_down_out    => count_down_out         -- Sortie compteur down
        );

end Behavioral;
