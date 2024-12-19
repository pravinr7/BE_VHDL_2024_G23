library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity verrin is
    Port ( clk_50MHz      : in std_logic;
           rst            : in std_logic;
           data_adc       : in std_logic;
           clk_adc        : out std_logic;
           cs_n           : out std_logic;
           angle_barre    : out std_logic_vector(11 downto 0);
           frequence      : in std_logic_vector(15 downto 0);
           C_duty         : in std_logic_vector(15 downto 0);
           butee_g        : in std_logic_vector(15 downto 0);
           butee_d        : in std_logic_vector(15 downto 0);
           sens           : in std_logic;
           enable         : in std_logic;
           pwm_out        : out std_logic;
           out_sens       : out std_logic;
           f_g             : out std_logic;
           f_d             : out std_logic
         );
end verrin;

architecture arch_verrin of verrin is

    -- Composants internes
    component adc is
        Port ( clk      : in std_logic;
               rst      : in std_logic;
               data_adc : in std_logic;
               clk_adc  : out std_logic;
               cs_n     : out std_logic;
               angle_barre : out std_logic_vector(11 downto 0)
             );
    end component;

    component PWM is
        port (
            clk_50MHz, raz_n : in std_logic;
            frequence, C_duty : in std_logic_vector (15 downto 0);
            pwm_out : out std_logic
        );
    end component;

    component control_butee is
        port (
            pwm_in, sens, enable : in std_logic;
            butee_g, butee_d : in std_logic_vector (15 downto 0);
            angle_barre : in std_logic_vector (11 downto 0);
            out_pwm, out_sens, f_g, f_d : out std_logic
        );
    end component;

    -- Signaux internes
    signal angle_barre_internal : std_logic_vector(11 downto 0);
    signal pwm_internal : std_logic;
    signal sens_internal : std_logic;
    signal f_g_internal, f_d_internal : std_logic;

begin

    -- Instanciation du module ADC
    adc_inst : adc
        port map (
            clk => clk_50MHz,
            rst => rst,
            data_adc => data_adc,
            clk_adc => clk_adc,
            cs_n => cs_n,
            angle_barre => angle_barre_internal
        );

    -- Instanciation du module PWM
    pwm_inst : PWM
        port map (
            clk_50MHz => clk_50MHz,
            raz_n => rst,
            frequence => frequence,
            C_duty => C_duty,
            pwm_out => pwm_internal
        );

    -- Instanciation du module Control Butee
    control_butee_inst : control_butee
        port map (
            pwm_in => pwm_internal,
            sens => sens_internal,
            enable => enable,
            butee_g => butee_g,
            butee_d => butee_d,
            angle_barre => angle_barre_internal,
            out_pwm => pwm_out,
            out_sens => out_sens,
            f_g => f_g_internal,
            f_d => f_d_internal
        );

    -- Logique pour connecter les signaux de sortie
    f_g <= f_g_internal;
    f_d <= f_d_internal;
    sens_internal <= sens;  -- transmettre le sens en interne

end arch_verrin;
