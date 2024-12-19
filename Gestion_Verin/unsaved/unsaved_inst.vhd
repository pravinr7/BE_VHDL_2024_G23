	component unsaved is
		port (
			clk_clk                                   : in  std_logic                    := 'X';             -- clk
			pio_0_external_connection_export          : out std_logic_vector(7 downto 0);                    -- export
			pio_1_external_connection_export          : in  std_logic_vector(1 downto 0) := (others => 'X'); -- export
			reset_reset_n                             : in  std_logic                    := 'X';             -- reset_n
			verrin_co_0_clk_adc_writeresponsevalid_n  : out std_logic;                                       -- writeresponsevalid_n
			verrin_co_0_cs_n_writeresponsevalid_n     : out std_logic;                                       -- writeresponsevalid_n
			verrin_co_0_data_adc_beginbursttransfer   : in  std_logic                    := 'X';             -- beginbursttransfer
			verrin_co_0_out_sens_writeresponsevalid_n : out std_logic;                                       -- writeresponsevalid_n
			verrin_co_0_pwm_out_writeresponsevalid_n  : out std_logic                                        -- writeresponsevalid_n
		);
	end component unsaved;

	u0 : component unsaved
		port map (
			clk_clk                                   => CONNECTED_TO_clk_clk,                                   --                       clk.clk
			pio_0_external_connection_export          => CONNECTED_TO_pio_0_external_connection_export,          -- pio_0_external_connection.export
			pio_1_external_connection_export          => CONNECTED_TO_pio_1_external_connection_export,          -- pio_1_external_connection.export
			reset_reset_n                             => CONNECTED_TO_reset_reset_n,                             --                     reset.reset_n
			verrin_co_0_clk_adc_writeresponsevalid_n  => CONNECTED_TO_verrin_co_0_clk_adc_writeresponsevalid_n,  --       verrin_co_0_clk_adc.writeresponsevalid_n
			verrin_co_0_cs_n_writeresponsevalid_n     => CONNECTED_TO_verrin_co_0_cs_n_writeresponsevalid_n,     --          verrin_co_0_cs_n.writeresponsevalid_n
			verrin_co_0_data_adc_beginbursttransfer   => CONNECTED_TO_verrin_co_0_data_adc_beginbursttransfer,   --      verrin_co_0_data_adc.beginbursttransfer
			verrin_co_0_out_sens_writeresponsevalid_n => CONNECTED_TO_verrin_co_0_out_sens_writeresponsevalid_n, --      verrin_co_0_out_sens.writeresponsevalid_n
			verrin_co_0_pwm_out_writeresponsevalid_n  => CONNECTED_TO_verrin_co_0_pwm_out_writeresponsevalid_n   --       verrin_co_0_pwm_out.writeresponsevalid_n
		);

