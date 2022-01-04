library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.testing_package.all;

entity FEC_etb is
end FEC_etb;


architecture tb_arch of FEC_etb is 
	component FEC
	port(
		clk1, clk2, reset, data_ready, enable, data_in: in std_logic;
		X,Y,valid: out std_logic;
		output_buffer: out std_logic_vector(191 downto 0)
	);
	end component; 
	
	signal clk1: std_logic :='0';
	signal clk2: std_logic :='0';
	signal reset: std_logic :='0';
	signal data_ready: std_logic :='0';
	signal enable: std_logic :='0';
	signal output_buffer:  std_logic_vector(191 downto 0);
	--signal q:   std_logic_vector(5 downto 0);
	signal data_in: std_logic;
	signal X,Y,valid: std_logic;
	constant data: std_logic_vector(95 downto 0):=X"558AC4A53A1724E163AC2BF9";
	--constant data_out_expected : std_logic_vector(191 downto 0) := X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
         
	constant period: time:= 10 ns;
	
	begin
	uut: FEC
	port map(clk1 => clk1,
				clk2 => clk2,
				reset => reset,
				data_ready=>data_ready,
				enable=>enable,
				data_in=>data_in,
				valid=>valid,
				X=>X,
				Y=>Y,
				output_buffer=>output_buffer
				);
				
	clk1<=not clk1 after period/2;
	clk2<=not clk2 after period/4;
	process
	begin
	FEC_init(reset, data_ready, enable, data_in);
	wait for (period); 
	reset <= '0'; 
	wait for (period); 
	data_ready<='1';
	wait for (period);
	sample_FEC(data_in, enable);
	end process;

	
	--self-check verifier
	process

   begin
		wait for (200*period);
		FEC_eval(output_buffer);
  end process;

end tb_arch;
	
	