	component anemoVER_1_0 is
		port (
			clk_clk                               : in  std_logic                    := 'X'; -- clk
			in_freq_anemometre_beginbursttransfer : in  std_logic                    := 'X'; -- beginbursttransfer
			reset_reset_n                         : in  std_logic                    := 'X'; -- reset_n
			test_export                           : out std_logic_vector(7 downto 0)         -- export
		);
	end component anemoVER_1_0;

	u0 : component anemoVER_1_0
		port map (
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                clk.clk
			in_freq_anemometre_beginbursttransfer => CONNECTED_TO_in_freq_anemometre_beginbursttransfer, -- in_freq_anemometre.beginbursttransfer
			reset_reset_n                         => CONNECTED_TO_reset_reset_n,                         --              reset.reset_n
			test_export                           => CONNECTED_TO_test_export                            --               test.export
		);

