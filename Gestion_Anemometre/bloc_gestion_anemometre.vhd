-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Thu Dec 05 19:43:49 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY bloc_gestion_anemometre IS 
	PORT
	(
		clk_50M :  IN  STD_LOGIC;
		in_freq_anemometre :  IN  STD_LOGIC;
		start_stop :  IN  STD_LOGIC;
		raz_n :  IN  STD_LOGIC;
		continu :  IN  STD_LOGIC;
		data_valid :  OUT  STD_LOGIC;
		data_anemometre :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END bloc_gestion_anemometre;

ARCHITECTURE bdf_type OF bloc_gestion_anemometre IS 

COMPONENT div_1hz
	PORT(clk_50M : IN STD_LOGIC;
		 raz_n : IN STD_LOGIC;
		 led : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT bloc_compteur
	PORT(clk_1Hz : IN STD_LOGIC;
		 raz_n : IN STD_LOGIC;
		 in_freq_anemometre : IN STD_LOGIC;
		 counter_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bloc_choix_mode
	PORT(clk : IN STD_LOGIC;
		 raz_n : IN STD_LOGIC;
		 start_stop : IN STD_LOGIC;
		 continu : IN STD_LOGIC;
		 data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_valid : OUT STD_LOGIC;
		 data_anem : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN 



b2v_inst : div_1hz
PORT MAP(clk_50M => clk_50M,
		 raz_n => raz_n,
		 led => SYNTHESIZED_WIRE_3);


b2v_inst1 : bloc_compteur
PORT MAP(clk_1Hz => SYNTHESIZED_WIRE_3,
		 raz_n => raz_n,
		 in_freq_anemometre => in_freq_anemometre,
		 counter_out => SYNTHESIZED_WIRE_2);


b2v_inst2 : bloc_choix_mode
PORT MAP(clk => SYNTHESIZED_WIRE_3,
		 raz_n => raz_n,
		 start_stop => start_stop,
		 continu => continu,
		 data_in => SYNTHESIZED_WIRE_2,
		 data_valid => data_valid,
		 data_anem => data_anemometre);


END bdf_type;