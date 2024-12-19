library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity avalon_interface is
    Port (
        clk         : in  std_logic; -- Horloge principale
        rst_n       : in  std_logic; -- Reset actif bas
        avalon_addr : in  std_logic_vector(2 downto 0); -- Adresse (3 bits pour 6 registres)
        avalon_data : inout std_logic_vector(15 downto 0); -- Données Avalon (lecture/écriture)
        write_enable: in  std_logic; -- Écriture active
        read_enable : in  std_logic; -- Lecture active

        -- Entrées/Sorties des sous-modules
        data_adc    : in  std_logic; -- Donnée série de l'ADC
        pwm_out     : out std_logic; -- Signal PWM
        out_sens    : out std_logic; -- Direction du moteur
        f_g         : out std_logic; -- Fin de course gauche
        f_d         : out std_logic  -- Fin de course droite
    );
end avalon_interface;

architecture Behavioral of avalon_interface is

    -- Registres Avalon
    signal freq      : std_logic_vector(15 downto 0) := (others => '0');
    signal duty      : std_logic_vector(15 downto 0) := (others => '0');
    signal butee_g   : std_logic_vector(15 downto 0) := "0000011111010000"; -- Par défaut 2000
    signal butee_d   : std_logic_vector(15 downto 0) := "0000111111111111"; -- Par défaut 4095
    signal config    : std_logic_vector(15 downto 0) := (others => '0');
    signal angle_barre : std_logic_vector(11 downto 0) := (others => '0');

    -- Signaux internes pour la communication entre les modules
    signal enable_pwm : std_logic;
    signal sens       : std_logic;
    signal reset_pwm  : std_logic;
    signal fin_course_g : std_logic := '0';
    signal fin_course_d : std_logic := '0';

    -- Signal intermédiaire pour connecter pwm
    signal pwm_signal : std_logic;

begin

    -- Processus d'écriture dans les registres
    write_process : process (clk, rst_n)
    begin
        if rst_n = '0' then
            -- Initialisation des registres
            freq <= (others => '0');
            duty <= (others => '0');
            butee_g <= "0000011111010000";
            butee_d <= "0000111111111111";
            config <= (others => '0');
        elsif rising_edge(clk) then
            if write_enable = '1' then
                case avalon_addr is
                    when "000" => freq <= avalon_data; -- Registre 0 : freq
                    when "001" => duty <= avalon_data; -- Registre 1 : duty
                    when "010" => butee_g <= avalon_data; -- Registre 2 : butee_g
                    when "011" => butee_d <= avalon_data; -- Registre 3 : butee_d
                    when "100" => config <= avalon_data; -- Registre 4 : config
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    -- Processus de lecture des registres
    read_process : process (clk, rst_n)
    begin
        if rst_n = '0' then
            avalon_data <= (others => '0');
        elsif rising_edge(clk) then
            if read_enable = '1' then
                case avalon_addr is
                    when "000" => avalon_data <= freq; -- Registre 0 : freq
                    when "001" => avalon_data <= duty; -- Registre 1 : duty
                    when "010" => avalon_data <= butee_g; -- Registre 2 : butee_g
                    when "011" => avalon_data <= butee_d; -- Registre 3 : butee_d
                    when "100" => avalon_data <= config; -- Registre 4 : config
                    when "101" => avalon_data <= "0000" & angle_barre; -- Registre 5 : angle_barre
                    when others => avalon_data <= (others => '0');
                end case;
            end if;
        end if;
    end process;

    -- Décodage du registre config
    enable_pwm <= config(1);
    sens <= config(2);
    reset_pwm <= not config(0);

    -- Fin de course
    config(3) <= fin_course_d;
    config(4) <= fin_course_g;

    -- Instanciation des sous-modules
    pwm_inst : entity work.pwm
        port map (
            clk_50mhz => clk,
            reset_n   => reset_pwm,
            duty      => duty(7 downto 0),
            Nfreq     => freq(7 downto 0),
            rst       => reset_pwm,
            pwm_out   => pwm_signal -- Connecte au signal intermédiaire
        );

    adc_inst : entity work.adc
        port map (
            clk         => clk,
            rst         => reset_pwm,
            data_adc    => data_adc,
            clk_adc     => open, -- Peut être connecté si nécessaire
            cs_n        => open, -- Peut être connecté si nécessaire
            angle_barre => angle_barre
        );

    control_butee_inst : entity work.control_butee
        port map (
            pwm_in      => pwm_signal, -- Connecte le signal intermédiaire
            sens        => sens,
            enable      => enable_pwm,
            butee_g     => butee_g,
            butee_d     => butee_d,
            angle_barre => angle_barre,
            pwm_out     => pwm_out, -- Sortie finale
            out_sens    => out_sens,
            f_g         => fin_course_g,
            f_d         => fin_course_d
        );

end Behavioral;
