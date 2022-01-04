library ieee,std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use WORK.testing_package.all;

entity modulator_etb is
end modulator_etb;


architecture tb_arch of modulator_etb is 
	component modulator
	port(
		clk, reset, data_ready, data_in: in std_logic;
		valid: out std_logic;
		NConstMap0, NConstMap1: out integer
		);
	end component; 
	
	signal clk: std_logic :='0';
	signal reset: std_logic :='0';
	signal data_ready: std_logic :='0';
	signal data_in: std_logic;
	signal valid: std_logic;
	signal NConstMap0, NConstMap1: integer;
	constant data: std_logic_vector(191 downto 0):=X"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";

         
	constant period: time:= 10 ns;
	
	begin
	uut: modulator
	port map(clk => clk,
				reset => reset,
				data_ready=>data_ready,
				valid=>valid,
				data_in=>data_in,
				NConstMap0=>NConstMap0,
				NConstMap1=>NConstMap1
				);
				
	clk<=not clk after period/2;
	process
	begin
	modulator_init(reset,data_ready,data_in);
	wait for (period); 
	reset <= '0'; 
	wait for (period); 
	data_ready<='1';
	sample_modulator(data_in);
	end process;

	
	
	--self-check verifier
	process
	begin
		modulator_eval(NConstMap1,NConstMap0,valid);
   end process;
	
	
	
	
end tb_arch;
	
	