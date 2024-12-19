library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity top_level is
    port ( 
        clk         : in  std_logic;                        -- Horloge principale
        rst         : in  std_logic;                        -- Reset actif bas
        data_adc    : in  std_logic;                        -- Données ADC série
        bouton_g    : in  std_logic;                        -- Bouton pour direction gauche
        bouton_d    : in  std_logic;                        -- Bouton pour direction droite
        bouton_m    : in  std_logic;                        -- Bouton pour activer/désactiver
        
        clk_adc     : out std_logic;                        -- Horloge pour l'ADC
        cs_n        : out std_logic;                        -- Chip Select pour l'ADC
        pwm_out     : out std_logic;                        -- Signal PWM final
        sens_out    : out std_logic;                        -- Signal de direction final
		  led_d		  : out std_logic;
		  led_g       : out std_logic;
		  led_s       : out std_logic;
		  out_bip     : out std_logic;
        leds        : out std_logic_vector(7 downto 0)      -- LEDs pour visualisation
    );
end top_level;

architecture Behavioral of top_level is

    -- Composants utilisés
    component Nios
        port (  
            clk_clk           : in std_logic;  
            data_adc_export   : in std_logic_vector(11 downto 0);
            data_valid_export : in std_logic;          
            reset_reset_n     : in std_logic;
            go_export         : out std_logic; 
				code_fonction_export		: in std_logic_vector(3 downto 0);
				bouton_d_export   : in  std_logic;             --   bouton_d.export
				bouton_g_export   : in  std_logic;             --   bouton_g.export
				bouton_m_export   : in  std_logic;             --   bouton_m.export
            freq_pwm_export   : out std_logic_vector(15 downto 0); -- Fréquence du PWM
            duty_pwm_export   : out std_logic_vector(7 downto 0);  -- Duty cycle du PWM
				pwm_out_export 	: out std_logic;
				enable_out_export : out std_logic;
            butee_g_export    : out std_logic_vector(11 downto 0); -- Limite gauche
            butee_d_export    : out std_logic_vector(11 downto 0)  -- Limite droite
        );
    end component;

    component adc
        port ( 
            clk             : in  std_logic; 
            rst             : in  std_logic; 
            go              : in  std_logic; 
            data_adc        : in  std_logic; 
            angle_barre     : out std_logic_vector(11 downto 0); 
            data_valid      : out std_logic;
            clk_adc         : out std_logic;
            cs_n            : out std_logic 
        );
    end component;

    component pwm
        port (
            clk       : in  std_logic; 
            reset     : in  std_logic; 
            freqIn    : in  integer;          -- Fréquence définie directement en entrée
            dutyIn    : in  integer;          -- Rapport cyclique (duty cycle) défini directement en entrée
				bouton_g  : in std_logic;
				bouton_d  : in std_logic;
            sens      : out std_logic;
            pwm_out   : out std_logic         -- Signal de sortie PWM
        );
    end component;

    component control_butee
        port (
            angle_barre  : in  std_logic_vector(11 downto 0);
        butee_g      : in  std_logic_vector(11 downto 0);
        butee_d      : in  std_logic_vector(11 downto 0);
        pwm_signal   : in  std_logic;
        sens_rotation : in  std_logic;
        fin_course_g : out std_logic;
        fin_course_d : out std_logic;
        pwm_out      : out std_logic
				);
    end component;

	 component gestion_bp
			port (
				clk       	: in  std_logic; 
        rst     	: in  std_logic; 
        bp_babord 	: in  std_logic;         
        bp_tribord	: in  std_logic;          
        Ledbabord  	: out std_logic; 
        Ledtribord 	: out std_logic;
        Ledstby   	: out std_logic;
		  	codeFonction: out std_logic_vector(3 downto 0);
		  bp_stby 		: in 	std_logic
		  --out_bip	  	: out std_logic
		  );
		 end component;
		 
    -- Signaux internes pour la liaison
    signal angle_barre_int : std_logic_vector(11 downto 0);
    signal go_int          : std_logic;
    signal data_valid_int  : std_logic;
    signal pwm_signal      : std_logic;
    signal sens_signal     : std_logic;
    signal enable_signal   : std_logic;
    signal freq_pwm        : std_logic_vector(15 downto 0);
    signal duty_pwm        : std_logic_vector(7 downto 0);
    signal butee_g_signal  : std_logic_vector(11 downto 0);
    signal butee_d_signal  : std_logic_vector(11 downto 0);
    signal fd  : std_logic;
	 signal fg : std_logic;
	 signal codefonc			: std_logic_vector(3 downto 0);
	 
begin

    -- Instanciation du Nios II
   -- NIOS_INST : Nios
      --  port map (
           -- clk_clk           => clk,  
          --  data_adc_export   => angle_barre_int,
          --  data_valid_export => data_valid_int,
           -- reset_reset_n     => rst,
           -- go_export         => go_int,
           -- freq_pwm_export   => freq_pwm,
          --  duty_pwm_export   => duty_pwm,
          --  butee_g_export    => butee_g_signal,
          --  butee_d_export    => butee_d_signal,
			--	bouton_d_export	=> bouton_d,
			--	bouton_g_export	=> bouton_g,
			--	bouton_m_export	=> bouton_m,
			--	enable_out_export => enable_signal,
			--	pwm_out_export    => sens_signal,
			--	code_fonction_export => codefonc
       -- );

    -- Instanciation de la gestion ADC
    ADC_INST : adc
        port map (
            clk         => clk,
            rst         => rst,
            go          => go_int,
            data_adc    => data_adc,
            angle_barre => angle_barre_int,
            data_valid  => data_valid_int,
            clk_adc     => clk_adc,
            cs_n        => cs_n
        );

    -- Instanciation du module PWM
    PWM_INST : pwm
        port map (
            clk       => clk,
            reset     => rst,
            freqIn    => 2000,
            dutyIn    => 1000,
				bouton_g  => bouton_g,
				bouton_d  => bouton_d,
            sens      => sens_signal,
            pwm_out   => pwm_signal
        );


		 -- Gestion_BP_inst : gestion_bp
		--	port map (
		  --clk       => clk, 
        --rst     	=> rst,
        --bp_babord 	=> bouton_g,        
        --bp_tribord	=> bouton_d,        
        --Ledbabord  	=> led_g,
        --Ledtribord 	=> led_d,
       -- Ledstby   	=> led_s,
		  --codeFonction =>  codefonc,
		  --bp_stby 		=> bouton_m
		  --out_bip	  	=> out_bip
		  --);

		gestion_butee : control_butee
			port map (
		  angle_barre     => angle_barre_int,
        butee_g      	=> "010111010101",--1493
        butee_d         => "011111010000",--2697
        pwm_signal      => pwm_signal,
        sens_rotation   => sens_signal,
        fin_course_g    => fg,
        fin_course_d    => fd,
        pwm_out         => pwm_out
		  );
		  
    -- Affichage sur les LEDs (8 MSB d'angle_barre_int)
    leds <= angle_barre_int(11 downto 4);
    sens_out <= sens_signal;
end Behavioral;
