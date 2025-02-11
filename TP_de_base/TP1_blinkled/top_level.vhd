library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity top_level is
    Port (
        clk : in STD_LOGIC;          -- Horloge d'entr�e � 50 MHz
        rst : in STD_LOGIC;          -- R�initialisation
        led : out STD_LOGIC_VECTOR (3 downto 0)  -- Sortie des LEDs
    );
end top_level;

architecture Behavioral of top_level is
    -- D�claration des composants
    component TP1_blinkled
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            led_out : out STD_LOGIC
        );
    end component;

    component compteur
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            led : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- Signaux internes
    signal led_out: STD_LOGIC;
    

begin

    -- Instance du diviseur de fr�quence
    U1: TP1_blinkled
        Port Map (
            clk => clk,
            rst => rst,
            led_out => led_out
        );

    -- Instance du compteur BCD
    U2: compteur
        Port Map (
            clk => led_out,
            rst => rst,
            led => led
        );

end Behavioral;