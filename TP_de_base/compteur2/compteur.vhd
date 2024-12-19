library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity compteur is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;  -- Reset asynchronique pour réinitialiser le compteur
        led : out STD_LOGIC_VECTOR (3 downto 0)
    );
end compteur;

architecture Behavioral of compteur is
    signal count : STD_LOGIC_VECTOR (3 downto 0) := "0000";
begin

    process (clk, rst)
    begin
        if rst = '0' then
            count <= "0000";  -- Réinitialise le compteur à 0
        elsif rising_edge(clk) then
            if count = "1001" then  -- Si le compteur atteint 9
                count <= "0000";  -- Recommence à 0
            else
                count <= count + 1;  -- Incrémente le compteur
            end if;
        end if;
    end process;

    led <= count;  -- Les LEDs affichent la valeur du compteur

end Behavioral;