library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity avalon1_anemo is
    port (
       
		clk, chipselect, write_n : in std_logic; 
		reset_n : in std_logic_vector (2 downto 0); 
		writedata : in std_logic_vector (15 downto 0); 
		readdata : out std_logic_vector (15 downto 0); 
		address: std_logic
    );
end entity avalon1_anemo;

architecture arch_avalon_anemo of avalon1_anemo is

component bloc_gestion_anemometre
port( 

clk_50M, raz_n, start_stop,in_freq_anemometre : in std_logic ;
continu : in std_logic_vector (2 downto 0);
data_valid : out std_logic;
data_anemometre : out std_logic_vector (7 downto 0)

);

end component;

signal araz_n ,astart_stop , adata_valid, ain_freq_anemometre : std_logic;
signal acontinu : std_logic_vector(2 downto 0);
signal adata_anemometre       : std_logic_vector(7 downto 0);

begin

anemo : bloc_gestion_anemometre port map(

				clk_50M => clk,
				raz_n =>  not reset_n, 
				start_stop => astart_stop, 
				continu => acontinu, 
				in_freq_anemometre => ain_freq_anemometre, 
				data_valid => adata_valid, 
				data_anemometre => adata_anemometre 
				);

	pWrite : process (Clk, reset_n)
   
	begin
         if reset_n = '0' then 
				araz_n <= '0'; 
				acontinu <="000";
				astart_stop <= '0';
		 	
			elsif (clk'event and clk = '1') then 
				if chipselect ='1' and write_n = '0' then 
					if address = '0' then
						astart_stop  <= writedata(0); 
						araz_n  <= writedata(1); 
						acontinu  <= writedata (4 downto 2); 
					end if; 
				end if; 
			end if;
			
	end process pwrite; 
	
	pRead: process(address) 
	
	begin 
	
		case address is 
 
		when '1' => readdata <= "0000" & "000" & adata_valid & adata_anemometre ; 
		when others => readdata <= (others => '0');    
		end case; 
		
	end process pread; 
		  
		  
    
end arch_avalon_anemo;
