library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_level is
end tb_top_level;

architecture Behavioral of tb_top_level is

    -- Signals pour stimuler l'entité top_level
    signal clk_50M           : std_logic := '0';
    signal raz_n             : std_logic := '1';
    signal in_freq_anemometre : std_logic := '0';
    signal leds              : std_logic_vector(8 downto 0);
    signal counter_out       : std_logic_vector(8 downto 0);
    signal count_up_out      : std_logic_vector(8 downto 0);
    signal count_down_out    : std_logic_vector(8 downto 0);

    -- Période de l'horloge à 50 MHz (20 ns)
    constant clk_period : time := 20 ns;

begin

    -- Génération de l'horloge 50 MHz
    clk_process : process
    begin
        clk_50M <= '0';
        wait for clk_period / 2;
        clk_50M <= '1';
        wait for clk_period / 2;
    end process;

    -- Simulation de la réinitialisation (reset)
    reset_process : process
    begin
        raz_n <= '0';  -- Reset actif
        wait for 100 ns;
        raz_n <= '1';  -- Reset désactivé
        wait;
    end process;

    -- Simulation de l'entrée in_freq_anemometre (envoi de fronts montants pour tester le compteur)
    freq_anemometre_process : process
    begin
        wait for 200 ns;
        while now < 2 ms loop
            in_freq_anemometre <= not in_freq_anemometre;
            wait for 500 ns;  -- Période de l'anémomètre simulée (variable)
        end loop;
        wait;
    end process;

    -- Instance du module top_level
    uut : entity work.top_level
        port map (
            clk_50M           => clk_50M,
            raz_n             => raz_n,
            in_freq_anemometre => in_freq_anemometre,
            leds              => leds,
            counter_out       => counter_out,
            count_up_out      => count_up_out,
            count_down_out    => count_down_out
        );

end Behavioral;
