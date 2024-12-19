library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.all;

entity avalon_anemo is
    port (
       
		clk, chipselect, reset_n, write_n : in std_logic; 
		writedata : in std_logic_vector (31 downto 0); 
		readdata : out std_logic_vector (31 downto 0); 
		address  : in std_logic_vector(1 downto 0);
		
		in_freq_anemometre : in std_logic
		
		
    );
end entity avalon_anemo;

architecture arch_avalon_anemo of avalon_anemo is

component top_level_anemometre
port( 

clk_50M, raz_n, continu, start_stop,in_freq_anemometre : in std_logic ;
data_valid : out std_logic;
data_anemometre : out std_logic_vector (7 downto 0)

);

end component;

--signal acontinu, astart_stop, araz_n , adata_valid : std_logic;
--signal adata_anemometre : std_logic_vector(7 downto 0);

signal config : std_logic_vector(2 downto 0);  -- b2=Start/Stop, b1=continu, b0=raz_n
    signal code : std_logic_vector(9 downto 0);    -- b9=valid, b7..b0=data_anemometre



begin

inst_anemo : entity work.top_level_anemometre 
port map(

				clk_50M => clk,
				raz_n =>  config(0), 
				start_stop => config(2), 
				continu => config(1), 
				in_freq_anemometre => in_freq_anemometre, 
				data_valid => code(9), 
				data_anemometre => code(7 downto 0)
				);
				
code(8)<='0';

	pWrite : process (clk, reset_n)
   
	begin
         if reset_n 	= '0' then 
				--araz_n 	<= '0'; 
				--acontinu <='0';
				--astart_stop <= '0';
				config <= (others => '0');
			
			elsif (clk'event and clk = '1') then 
				if chipselect ='1' and write_n = '0' then 
					if address = "00" then
						--config <= writedata;
						--astart_stop  <= config(2);  
						--acontinu  	<= config (1); 
						--araz_n  		<= config(0);
						config <= writedata(2 downto 0);  -- Configuration (Start/Stop, Continu, Raz_n)
					end if; 
				end if; 
			end if;
			
	end process pwrite; 
	
	pRead: process(address, config, code) 
	
	begin 
	
		if address = "00" then
            -- Lecture de la configuration, étendue sur 32 bits
            readdata <= X"0000000"&"0"&config;  -- config est sur 3 bits, on ajoute 29 zéros
		 end if;
        if address = "01" then
            -- Lecture du code, étendue sur 32 bits
            readdata <= X"00000"&"00"&code;   -- code est sur 10 bits, on ajoute 23 zéros
	 end if; 
		
	end process pread; 
		  
		  
    
end arch_avalon_anemo;
