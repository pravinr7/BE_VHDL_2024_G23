library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adc is
    Port ( 
           clk         : in std_logic;                         -- Horloge principale
           rst         : in std_logic;                         -- Reset actif à '0'
           data_adc    : in std_logic;                         -- Données reçues de l'ADC
           clk_adc     : out std_logic;                        -- Horloge pour l'ADC
           cs_n        : out std_logic;                        -- Chip Select pour l'ADC
           angle_barre : out std_logic_vector(11 downto 0);    -- Données converties
           go          : in std_logic;                         -- Signal du Nios pour démarrer la conversion
           data_valid  : out std_logic                         -- Signal vers le Nios : conversion terminée
         );
end adc;

architecture Behavioral of adc is

    -- Signaux internes
    signal clk_adc_int    : std_logic;
    signal cs_int         : std_logic := '1';
    signal start_conv     : std_logic;
    signal count_fronts   : integer range 0 to 15;
    signal count_conv     : integer range 0 to 100000;
    signal count          : integer range 0 to 50;
    signal data_int       : std_logic_vector(11 downto 0) := (others => '0');
    signal data_ready     : std_logic := '0'; -- Indique que la donnée est prête pour le Nios II

    -- Machine à états
    type state_type is (IDLE, READ_VAL);
    signal state : state_type;

begin

    -------------------------------------------------------------
    -- Machine à état pour gérer la conversion
    -------------------------------------------------------------
    pilote_adc : process (clk, rst)
    begin
        if rst = '0' then
            state <= IDLE;
            data_ready <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if go = '1' then  -- Le Nios II demande une conversion
                        state <= READ_VAL;
                        data_ready <= '0';
                    end if;
                when READ_VAL =>
                    if cs_int = '0' then  -- Conversion terminée
                        state <= IDLE;
                        data_ready <= '1';  -- La donnée est prête
                    end if;
            end case;
        end if;
    end process;

    -------------------------------------------------------------
    -- Génération de clock de 1 MHz pour l'ADC
    -------------------------------------------------------------
    clk_1MHz : process (clk, rst)
    begin
        if rst = '0' then
            count <= 0;
            clk_adc_int <= '0';
        elsif rising_edge(clk) then
            if (count = 50-1) then
                count <= 0;
                clk_adc_int <= not clk_adc_int;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    -------------------------------------------------------------
    -- Comptage de fronts d'horloge pour l'ADC
    -------------------------------------------------------------
    compt_fronts : process (clk_adc_int, rst)
    begin
        if rst = '0' then
            count_fronts <= 0;
        elsif rising_edge(clk_adc_int) then
            if (count_fronts = 15) then
                count_fronts <= 0;
                cs_int <= '1';
            else
                count_fronts <= count_fronts + 1;
                cs_int <= '0';
            end if;
        end if;
    end process;

    -------------------------------------------------------------
    -- Registre à décalage pour récupérer les données de l'ADC
    -------------------------------------------------------------
    rec_dec : process (clk_adc_int, rst)
    begin
        if rst = '0' then
            data_int <= (others => '0');
            angle_barre <= (others => '0');
        elsif rising_edge(clk_adc_int) then
            if cs_int = '0' then
                data_int <= data_int(10 downto 0) & data_adc; -- Décalage des bits
            elsif cs_int = '1' then
                angle_barre <= data_int; -- Mise à jour de la valeur convertie
            end if;
        end if;
    end process;

    -------------------------------------------------------------
    -- Génération périodique toutes les 100ms (signal start_conv)
    -------------------------------------------------------------
    gene_start_conv : process (clk_adc_int, rst)
    begin
        if rst = '0' then
            count_conv <= 0;
            start_conv <= '0';
        elsif rising_edge(clk_adc_int) then
            if count_conv = 100000-1 then
                start_conv <= '1';
                count_conv <= 0;
            else
                start_conv <= '0';
                count_conv <= count_conv + 1;
            end if;
        end if;
    end process;

    -------------------------------------------------------------
    -- Assignation des signaux de sortie
    -------------------------------------------------------------
    cs_n <= cs_int;          -- Sortie Chip Select
    clk_adc <= clk_adc_int;  -- Horloge pour l'ADC
    data_valid <= data_ready; -- Indique au Nios II que la conversion est terminée

end Behavioral;