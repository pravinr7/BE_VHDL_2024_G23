library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- D�claration de l'entit� de l'additionneur 1 bit
entity compteur is
    Port (
        A1   : in  STD_LOGIC;  -- Entr�e 1
        B1   : in  STD_LOGIC;  -- Entr�e 2
        Cin  : in  STD_LOGIC;  -- Retenue d'entr�e
        S1   : out STD_LOGIC;  -- Somme
        Cout : out STD_LOGIC   -- Retenue de sortie
    );
end compteur;

-- D�claration de l'architecture de l'additionneur 1 bit
architecture Behavioral of compteur is
begin
    -- Calcul de la somme et de la retenue de sortie
    S1 <= A1 XOR B1 XOR Cin;  -- Somme
    Cout <= (A1 AND B1) OR (Cin AND (A1 XOR B1));  -- Retenue de sortie
end Behavioral;