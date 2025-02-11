library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity afficheur is
    Port (
        bin_input : in STD_LOGIC_VECTOR (3 downto 0); -- Valeur binaire d'entr�e (0-9)
        seg : out STD_LOGIC_VECTOR (6 downto 0)       -- Signaux pour les segments a-g
    );
end afficheur;

architecture Behavioral of afficheur is
begin

    process (bin_input)
    begin
        case bin_input is
            when "0000" =>  -- 0
                seg <= "1000000"; -- abcdefg (les segments a-f sont allum�s, g �teint)
            when "0001" =>  -- 1
                seg <= "1111001"; -- bc (les segments b et c sont allum�s)
            when "0010" =>  -- 2
                seg <= "0100100"; -- abdeg
            when "0011" =>  -- 3
                seg <= "0110000"; -- abcdg
            when "0100" =>  -- 4
                seg <= "0011001"; -- bcfg
            when "0101" =>  -- 5
                seg <= "0010010"; -- acdfg
            when "0110" =>  -- 6
                seg <= "0000010"; -- acdefg
            when "0111" =>  -- 7
                seg <= "1111000"; -- abc
            when "1000" =>  -- 8
                seg <= "0000000"; -- abcdefg
            when "1001" =>  -- 9
                seg <= "0010000"; -- abcfg
            when others =>  -- Pour toutes les autres combinaisons (erreur)
                seg <= "0000110"; -- E (segments a, d, e, f, g allum�s, b et c �teints)
        end case;
    end process;

end Behavioral;