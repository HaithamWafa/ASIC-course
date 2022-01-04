library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.testing_package.all;

entity randomizer_etb is
end randomizer_etb;


architecture tb_arch of randomizer_etb is 
	component randomizer
	port(
		clk, reset, load, data_ready: in std_logic;
		seed: in std_logic_vector(14 downto 0);
		
		data_in: in std_logic;
		data_out, valid: out std_logic
	);
	end component; 
	
	signal clk: std_logic :='0';
	signal reset: std_logic :='0';
	signal load: std_logic :='0';
	signal data_ready: std_logic :='0';
	signal seed:   std_logic_vector(14 downto 0);
	signal data_in: std_logic;
	signal data_out, valid: std_logic;
	constant data: std_logic_vector(95 downto 0):=X"ACBCD2114DAE1577C6DBF4C9";
	constant data_out_expected : std_logic_vector(95 downto 0) := X"558AC4A53A1724E163AC2BF9";
         
			
	--variable reset,data_ready, load, data_in: std_logic; variable seed: std_logic_vector(14 downto 0);
			
	constant period: time:= 10 ns;
	
	begin
	
	uut: randomizer
	port map(clk => clk, 
				reset => reset,
				load=>load,
				data_ready=>data_ready,
				seed=>seed,
				data_in=>data_in,
				valid=>valid,
				data_out=>data_out
				);
				
	clk<=not clk after period/2;
	process
	
	--variable test_pass: boolean;
	begin
	
	seed_randomizer(reset, data_ready, load, data_in, seed); --initial seeding

	wait for (period); 
	reset <= '0'; 
	wait for (period); 
	load<='0';
	wait for (period);
	sample_RAND(data_in, data_ready);
	end process;

	--self-check verifier
	process
     -- variable test_pass: boolean:=true;
   begin
	wait for 37 ns;
	for i in 95 downto 0 loop
		
	evaluate_output(data_out,i);
	
	end loop;
		wait;		
		
   end process;
	
	
	
	
end tb_arch;
	
	