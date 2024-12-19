library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adc is
    Port ( clk      : in std_logic;
           rst      : in std_logic;
           data_adc : in std_logic;
           clk_adc  : out std_logic; 
           cs_n     : out std_logic; 
           angle_barre : out std_logic_vector(11 downto 0)
         );
end spi;

architecture Behavioral of adc is

  signal clk_adc_int 	: std_logic;
  signal cs_int			: std_logic:='1';
  signal start_conv 		: std_logic;
  signal count_fronts	: integer range 0 to 14 ;
  signal count_conv  	: integer range 0 to 100000;
  signal count 			: integer range 0 to 50;
  signal data_int 		: std_logic_vector(11 downto 0):= (others => '0');
  
  type state_type is (IDLE, READ_VAL);
  signal state : state_Type;

begin

-------------------------------------------------------------
-- Machine à état
-------------------------------------------------------------
  pilote_adc : process (clk, rst)
  begin
    if rst = '0' then
      state <= IDLE;
    elsif rising_edge(clk) then
      case state is
        when IDLE =>
          if start_conv = '1' then
            state <= READ_VAL;
          else
            state <= IDLE;
          end if;
        when READ_VAL =>
          if cs_int = '0' then
            state <= IDLE;
          else
            state <= READ_VAL;
          end if;

      end case;
    end if;
  end process;

-------------------------------------------------------------
-- Génération de clock de 1 MHz
-------------------------------------------------------------
  
 clk_1MHz : process (clk, rst)
   
  begin
    if rst = '0' then
      count <= 0;
      clk_adc_int <= '0';
		
    elsif rising_edge(clk) then
      if (count = 50-1) then
        count <= 0;
        clk_adc_int <= not clk_adc_int;
      else
        count <= count + 1;
      end if;
    end if;
  end process;
 
-------------------------------------------------------------
-- Comptage de fronts
-------------------------------------------------------------
  compt_fronts : process (clk_adc_int, rst)
	 
  begin
    if rst = '0' then
      count_fronts <= 0;
		
    elsif (rising_edge (clk_adc_int)) then
      if (count_fronts = 14) then 
        count_fronts <= 0;
        cs_int 		<= '1';
      else
        count_fronts <= count_fronts + 1;
        cs_int 		<= '0';
      end if;
    end if;

  end process;
  
-------------------------------------------------------------
-- Registre à décalage
-------------------------------------------------------------
rec_dec : process (clk_adc_int, rst)
begin
    if rst = '0' then
        data_int <= (others => '0');
        angle_barre <= (others => '0'); 
    elsif rising_edge(clk_adc_int) then
        if cs_int = '0' then
            
            data_int <= data_int(10 downto 0) & data_adc; -- Décalage des bits et ajout de data_adc dans le LSB
        elsif cs_int = '1' then
            
            angle_barre <= data_int; -- Une fois cs_int désactivé, on met à jour angle_barre
        end if;
    end if;
end process;

-------------------------------------------------------------
-- Génération périodique toutes les 100ms
-------------------------------------------------------------
	gene_start_conv : process (clk_adc_int, rst)
    
  begin
    if rst = '0' then
      count_conv <= 0;
      start_conv <= '0';
    elsif rising_edge(clk_adc_int) then
      if count_conv = 100000-1 then
			start_conv <= '1';
			count_conv <= 0;
      else
			start_conv <= '0';
			count_conv <= count_conv + 1;

      end if;
    end if;

  end process;
cs_n<=cs_int;
clk_adc<=clk_adc_int;


end Behavioral;