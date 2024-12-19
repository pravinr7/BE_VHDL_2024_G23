library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity verrin_avalon is
    Port ( clk, chipselect, write_n, reset_n : in std_logic;
		writedata : in std_logic_vector (31 downto 0);
		readdata : out std_logic_vector (31 downto 0);
		address: std_logic_vector (4 downto 0);
           data_adc       : in std_logic;
           clk_adc        : out std_logic;
			    pwm_out      :out std_logic;
				 out_sens       :out  std_logic;
				 
           cs_n           : out std_logic
         );
end verrin_avalon;

architecture arch_verrin of verrin_avalon is

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
	 
	 signal  angle_barre    :  std_logic_vector(11 downto 0);
    signal  frequence      :  std_logic_vector(15 downto 0);
    signal C_duty         :  std_logic_vector(15 downto 0);
    signal    butee_g        :  std_logic_vector(15 downto 0);
    signal   butee_d        :  std_logic_vector(15 downto 0);
    signal  sens           : std_logic;
     signal   enable         :  std_logic;
    
     signal  f_g             :  std_logic;
     signal f_d             :  std_logic;
	          signal  rst            : std_logic;
				 signal  config_reg   :  std_logic_vector(2 downto 0);

begin

    -- Instanciation du module ADC
    adc_inst : adc
        port map (
            clk => clk,
            rst => rst,
            data_adc => data_adc,
            clk_adc => clk_adc,
            cs_n => cs_n,
            angle_barre => angle_barre_internal
        );

    -- Instanciation du module PWM
    pwm_inst : PWM
        port map (
            clk_50MHz => clk,
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
	 
	 rst <= config_reg(0);
	 enable <= config_reg(1);
	 sens<= config_reg(2);
    sens_internal <= sens;  -- transmettre le sens en interne-- Processus d'écriture des registres
    process(clk,reset_n)
    begin
        if reset_n = '1' then
            -- Reset des registres
            frequence <= (others => '0');
            c_duty <= (others => '0');
            butee_g<= (others => '0');
            butee_d <= (others => '0');
            config_reg <= (others => '0');
            angle_barre <= (others => '0');
        elsif rising_edge(clk) then
            -- Ecriture dans les registres via l'adresse et les signaux d'écriture
            if write_n = '1' then
                case address is
                    when "00000" =>  -- Adresse 0: freq
                        frequence <= writedata(15 downto 0);
                    when "00001" =>  -- Adresse 1: duty
                        C_duty<= writedata(15 downto 0);
                    when "00010" =>  -- Adresse 2: butee_g
                        butee_g <= writedata(15 downto 0);
                    when "00011" =>  -- Adresse 3: butee_d
                        butee_d <= writedata(15 downto 0);
                    when "00100" =>  -- Adresse 4: config
                        config_reg <= writedata(2 downto 0);
                    when others =>
                        -- Ne fait rien si l'adresse n'est pas valide
                        null;
                end case;
            end if;
        end if;
    end process;

	 	process_Read:process(address, frequence, C_duty,  butee_g, butee_d,f_g,f_d,config_reg, angle_barre) 
	begin
		case address is
		when "00000" =>  -- Adresse 0: freq
                        readdata <= X"0000" & frequence;
                    when "00001" =>  -- Adresse 1: duty
                        readdata <= X"0000" & C_duty;
                    when "00010" =>  -- Adresse 2: butee_g
                        readdata <= X"0000" & butee_g;
                    when "00011" =>  -- Adresse 3: butee_d
                        readdata <= X"0000" & butee_d;
                    when "00100" =>  -- Adresse 4: config
                      readdata <= X"000000"&"000" & f_g & f_d & config_reg;
                    when "00101" =>  -- Adresse 5: angle_barre (lecture seule)
                        readdata <= X"00000" & angle_barre; -- Angle de la barre (12 bits)
                    when others =>
                        -- Ne fait rien si l'adresse n'est pas valide
                        readdata <= (others => '0');  
		end case;
	end process process_Read ;
	 
	 
	 
end arch_verrin;
