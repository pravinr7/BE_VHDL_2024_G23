
module test (
	clk_clk,
	pio_0_external_connection_export,
	pio_1_external_connection_export,
	reset_reset_n,
	verrin_co_0_clk_adc_writeresponsevalid_n,
	verrin_co_0_cs_n_writeresponsevalid_n,
	verrin_co_0_data_adc_beginbursttransfer,
	verrin_co_0_out_sens_writeresponsevalid_n,
	verrin_co_0_pwm_out_writeresponsevalid_n);	

	input		clk_clk;
	output	[7:0]	pio_0_external_connection_export;
	input	[1:0]	pio_1_external_connection_export;
	input		reset_reset_n;
	output		verrin_co_0_clk_adc_writeresponsevalid_n;
	output		verrin_co_0_cs_n_writeresponsevalid_n;
	input		verrin_co_0_data_adc_beginbursttransfer;
	output		verrin_co_0_out_sens_writeresponsevalid_n;
	output		verrin_co_0_pwm_out_writeresponsevalid_n;
endmodule
