library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_avalon_anemo is
end tb_avalon_anemo;

architecture behavior of tb_avalon_anemo is
    -- Signals for the testbench
    signal clk : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal chipselect : std_logic := '0';
    signal write_n : std_logic := '1';
    signal writedata : std_logic_vector(15 downto 0) := (others => '0');
    signal readdata : std_logic_vector(15 downto 0);
    signal address : std_logic := '0';

    signal in_freq_anemometre : std_logic := '0';
    signal data_anemometre : std_logic_vector(7 downto 0);

    -- Clock generation
    constant clk_period : time := 20 ns;  -- 50 MHz clock (20 ns period)

    -- Component instantiation
    component avalon_anemo
        port (
            clk, chipselect, reset_n, write_n : in std_logic;
            writedata : in std_logic_vector(15 downto 0);
            readdata : out std_logic_vector(15 downto 0);
            address: std_logic;
            in_freq_anemometre : in std_logic;
            data_anemometre : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    -- Instantiate the device under test (DUT)
    DUT: avalon_anemo
        port map (
            clk => clk,
            chipselect => chipselect,
            reset_n => reset_n,
            write_n => write_n,
            writedata => writedata,
            readdata => readdata,
            address => address,
            in_freq_anemometre => in_freq_anemometre,
            data_anemometre => data_anemometre
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the DUT
--        reset_n <= '0';
--        wait for clk_period * 2;
--        reset_n <= '1';

        -- Simulate input frequency at 20 Hz (1/20s period = 50 ms)
        -- Generate a 20 Hz signal for `in_freq_anemometre`
        for i in 0 to 5 loop
            in_freq_anemometre <= '1';
            wait for 25 ms;  -- Half period (25 ms)
            in_freq_anemometre <= '0';
            wait for 25 ms;  -- Half period (25 ms)
        end loop;

        -- Finish the simulation
        wait;
    end process;
end behavior;
