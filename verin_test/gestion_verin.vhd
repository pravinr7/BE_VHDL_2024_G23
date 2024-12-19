library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;  -- Remplace std_logic_unsigned et std_logic_arith par numeric_std

entity gestion_verin is
port (
    clk, chipselect, write_n, reset_n, data_in : in std_logic;
    writedata : in std_logic_vector (31 downto 0);
    address : in std_logic_vector (2 downto 0);
    readdata : out std_logic_vector (31 downto 0);
    out_pwm, cs_n, clk_adc, out_sens : out std_logic
);
end entity;

ARCHITECTURE arch_gestion_verin of gestion_verin IS
    -- Signaux relatifs au circuit gestion PWM
    signal freq : unsigned (15 downto 0);
    signal duty : unsigned (15 downto 0);
    signal counter : unsigned (15 downto 0);
    signal pwm_on, enable : std_logic;
    
    -- Signaux relatifs au circuit contrôle butées
    signal butee_g, butee_d , angle_barre: unsigned (11 downto 0);
    signal sens, fin_course_d, fin_course_g : std_logic;

    -- Signaux relatifs à l'interface adc
    signal raz_compteur, fin, s_clk_adc, clk_1M, start_conv : std_logic;
    signal compt_front : integer range 0 to 15;
    signal s_data : unsigned (11 downto 0);

    -- Signaux relatifs au pilotage de tous les circuits
    signal config : std_logic_vector (2 downto 0);
    signal raz_n : std_logic;

BEGIN

    -- Circuit de gestion de la PWM
    --****************************************************
    -- Divise l'horloge pour gérer la fréquence PWM
    --*****************************************************
    divide: process (clk, raz_n)
    begin
        if raz_n = '0' then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            if counter >= freq then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process divide;

    --******************************************************
    -- Génère le rapport cyclique PWM
    --******************************************************
    compare: process (clk, raz_n)
    begin
        if raz_n = '0' then
            pwm_on <= '0';
        elsif rising_edge(clk) then
            if counter >= duty then
                pwm_on <= '0';
            else
                pwm_on <= '1';
            end if;
        end if;
    end process compare;

    -- Circuit de contrôle des butées
    --*******************************************************
    controle_butées: process (sens, butee_g, butee_d, angle_barre, pwm_on)
    begin
        if angle_barre >= butee_d then
            fin_course_d <= '1';
        else
            fin_course_d <= '0';
        end if;

        if angle_barre <= butee_g then
            fin_course_g <= '1';
        else
            fin_course_g <= '0';
        end if;
    end process controle_butées;

    -- Gère la sortie PWM en fonction de la direction et des butées
    out_pwm <= enable and pwm_on and (((not fin_course_d) and (not sens)) or ((not fin_course_g) and sens));
    out_sens <= sens;

    -- Interface avec ADC (MCP3201)
    --**********************************************************
    pilote_adc: process (raz_n, clk_1M)
        variable etat_pilote: integer range 0 to 4;
    begin
        if raz_n = '0' then
            etat_pilote := 0;
            cs_n <= '1';
            s_clk_adc <= '0';
            raz_compteur <= '1';
            angle_barre <= (others => '0');
        elsif rising_edge(clk_1M) then
            case etat_pilote is
                when 0 =>
                    if start_conv = '1' then 
                        etat_pilote := 1;
                        cs_n <= '0';
                        raz_compteur <= '0';
                    end if;
                when 1 =>
                    etat_pilote := 2; 
                    s_clk_adc <= '1'; 
                when 2 =>
                    etat_pilote := 3;
                    s_clk_adc <= '0';
                when 3 =>
                    if fin = '1' then 
                        etat_pilote := 4;
                        s_clk_adc <= '0'; 
                        cs_n <= '1'; 
                        angle_barre <= s_data; -- Mémorisation de la donnée
                    else 
                        etat_pilote := 2;
                        s_clk_adc <= '1';  
                    end if;
                when 4 =>
                    if start_conv = '0' then 
                        etat_pilote := 0;    
                        cs_n <= '1';
                        s_clk_adc <= '0';
                        raz_compteur <= '1';
                    end if;
                when others =>
                    etat_pilote := 0; 
                    s_clk_adc <= '0'; 
                    cs_n <= '1';
            end case;
        end if;
    end process pilote_adc;

    -- Processus de comptage des fronts d'horloge de clk_adc
    compt_fronts: process (s_clk_adc, raz_compteur)
    begin
        if raz_compteur = '1' then
            compt_front <= 0;
        elsif rising_edge(s_clk_adc) then
            if compt_front = 14 then
                compt_front <= 0;
                fin <= '1';
            else 
                compt_front <= compt_front + 1;
                fin <= '0';
            end if;
        end if;
    end process compt_fronts;

    -- Processus registre à décalage pour récupérer les données ADC
    rec_dec: process (s_clk_adc)
        variable i: integer;
    begin
        if rising_edge(s_clk_adc) then
            s_data(0) <= data_in;
            for i in 1 to 11 loop
                s_data(i) <= s_data(i-1);
            end loop;
        end if;
    end process rec_dec;

    -- Génération du signal 1 MHz
    gene_1M: process(clk, reset_n)
        variable count_gene_1M: integer range 0 to 25;    
    begin
        if raz_n = '0' then
            count_gene_1M := 0;
        elsif rising_edge(clk) then
            count_gene_1M := count_gene_1M + 1;
            if count_gene_1M = 24 then
                clk_1M <= not(clk_1M);
                count_gene_1M := 0;
            end if;
        end if;    
    end process gene_1M;

    -- Génération du start_conv toutes les 100 ms
    gene_start_conv: process(clk_1M, reset_n)
        variable count_conv : integer range 0 to 50000;    
    begin
        if raz_n = '0' then
            count_conv := 0;
        elsif rising_edge(clk_1M) then
            count_conv := count_conv + 1;
            if count_conv = 49999 then
                start_conv <= not start_conv
