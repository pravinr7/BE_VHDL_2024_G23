library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity PWM is

	port (
		clk_50MHz, raz_n: in std_logic;
		frequence, C_duty : in std_logic_vector (15 downto 0);
		pwm_out : out std_logic
			);
end entity;

ARCHITECTURE arch_pwm of PWM IS

	signal counter : std_logic_vector (31 downto 0);
	signal PWM_n : std_logic;
	BEGIN

   -- gestion de la freq 

		divide: process (clk_50MHz, raz_n)
		begin

			if raz_n = '0' then
				counter <= (others => '0');
			elsif clk_50MHz'event and clk_50MHz = '1' then
				if counter >= frequence then
					counter <= (others => '0');
				else
					counter <= counter + 1;
				end if;
			end if;
		end process divide;

    -- gestion duty

		compare: process (clk_50MHz, raz_n)
		begin
			if raz_n = '0' then
				PWM_n <= '0';
			elsif clk_50MHz'event and clk_50MHz = '1' then
				if counter >= C_duty then
					PWM_n <= '0';
				else
					PWM_n <= '1';
				end if;
			end if;
		end process compare;

    pwm_out <= PWM_n;

END arch_pwm ;