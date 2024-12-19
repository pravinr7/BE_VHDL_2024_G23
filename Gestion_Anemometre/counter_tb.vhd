library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_tb is
-- Aucune entrée ni sortie pour le testbench
end counter_tb;

architecture Behavioral of counter_tb is

    -- Déclaration des signaux de test
    signal clk_1Hz           : STD_LOGIC := '0';
    signal raz_n             : STD_LOGIC := '1';
    signal in_freq_anemometre: STD_LOGIC := '0';
    signal leds              : STD_LOGIC_VECTOR(15 downto 0);
	 
	 constant clk_freq : time := 1000 ms ;
	 --constant anemo_freq : time := 10 ms ;

    -- Composant à tester (DUT : Design Under Test)
    component counter_test
        Port (
            clk_1Hz           : in STD_LOGIC;
            raz_n             : in STD_LOGIC;
            in_freq_anemometre: in STD_LOGIC;
            leds              : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

begin

    -- Instanciation du DUT
    uut: counter_test
        Port map (
            clk_1Hz           => clk_1Hz,
            raz_n             => raz_n,
            in_freq_anemometre => in_freq_anemometre,
            leds              => leds
        );

    -- Génération de l'horloge à 1 Hz (période de 1 seconde)
    clk_process : process
    begin
        clk_1Hz <= '1';
		  wait for clk_freq/2;
		  clk_1Hz <= '0'; 
		  wait for clk_freq/2;
		  
    end process clk_process;

    -- Génération du signal de fréquence de l'anémomètre (avec une fréquence plus élevée)
    freq_anemometre_process : process
    begin
        
			in_freq_anemometre <= '0';
			wait for 10 ms;
			in_freq_anemometre <= '1';
			wait for 10 ms;
			
    end process freq_anemometre_process;

    -- Génération du reset asynchrone
    reset_process : process
    begin
        raz_n <= '1'; -- Appliquer le reset
        wait for 2000 ms;
        raz_n <= '0'; -- Retirer le reset
        
    end process reset_process;

end Behavioral;
