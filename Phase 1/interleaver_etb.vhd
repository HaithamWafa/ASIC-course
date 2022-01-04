library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.testing_package.all;

entity interleaver_etb is
end interleaver_etb;


architecture tb_arch of interleaver_etb is 
	component interleaver
	port(
		clk, reset, data_ready, enable, data_in: in std_logic;
		data_out, valid: out std_logic;
		output_buffer: out std_logic_vector(191 downto 0)
	);
	end component; 
	
	signal clk: std_logic :='0';
	signal reset: std_logic :='0';
	signal data_ready: std_logic :='0';
	signal enable: std_logic :='0';
	signal data_in: std_logic;
	signal data_out: std_logic;
	signal valid: std_logic;
	signal output_buffer: std_logic_vector(191 downto 0);
	constant data: std_logic_vector(191 downto 0):=X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
	--constant data_out_expected : std_logic_vector(191 downto 0) := X"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";
         
	constant period: time:= 10 ns;
	
	begin
	uut: interleaver
	port map(clk => clk,
				reset => reset,
				data_ready=>data_ready,
				enable=>enable,
				valid=>valid,
				data_in=>data_in,
				data_out=>data_out,
				output_buffer=>output_buffer
				);
				
	clk<=not clk after period/2;
	process
	begin
	interleaver_init(reset, data_ready, enable, data_in);
	wait for (period); 
	reset <= '0'; 
	wait for (period); 
	data_ready<='1';
	wait for (period);
	sample_interleaver(data_in, enable);
	end process;

	
	--self-check verifier
	process  begin
	wait for (390*period);
		interleaver_eval(output_buffer);
   end process;
	
	
	
end tb_arch;
	
	