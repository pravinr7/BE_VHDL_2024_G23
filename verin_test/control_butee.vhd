Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;



entity control_butee is

    port (
        angle_barre  : in  std_logic_vector(11 downto 0);
        butee_g      : in  std_logic_vector(11 downto 0);
        butee_d      : in  std_logic_vector(11 downto 0);
        pwm_signal   : in  std_logic;
        sens_rotation : in  std_logic;
        
        pwm_out      : out std_logic
    );
end entity control_butee;

architecture Behavioral of control_butee is


begin
    process( pwm_signal)
    begin
        -- Contrôle des butées gauche et droite
        if (unsigned(angle_barre) < unsigned(butee_g)) and (sens_rotation = '0') then
            pwm_out <= '0';
            
        elsif (unsigned(angle_barre) > unsigned(butee_d)) and (sens_rotation = '1') then
            pwm_out <= '0';
            
        else
            pwm_out <= pwm_signal;
            
        end if;
      end process;
end architecture Behavioral;
