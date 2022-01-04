library ieee;
use ieee.std_logic_1164.all;
entity randomizer is
	port(
		clk, reset, load, data_ready: in std_logic;
		seed: in std_logic_vector(14 downto 0);
		--q: out std_logic_vector(14 downto 0);
		data_in: in std_logic;
		data_out, valid: out std_logic
	);
end randomizer;
architecture randomizer_arch of randomizer is
	signal r_reg: std_logic_vector(14 downto 0);
	signal r_next: std_logic_vector(14 downto 0);
	signal temp: std_logic_vector(14 downto 0);
	signal ctrl: std_logic_vector(1 downto 0);
	signal xor1_out: std_logic;
begin

		process(clk,reset) begin
			if(reset='1') then
				r_reg<=(others=>'0');
			elsif (rising_edge(clk)) then
				r_reg<=r_next;
				if(load='0') then
				valid<='1';
				else
				valid<='0';
				end if;
			end if;
		end process;
		
		xor1_out<=r_reg(1) xor r_reg(0);
		temp<=xor1_out & r_reg(14 downto 1);
		ctrl<=load&data_ready;
	
		with (ctrl) select
			r_next <= 
				r_reg when "00",            --no op
				temp  when "01",     --linear feedback shift
				seed when "10",              -- parallel loading
				"000000000000000" when others;       --forbidden conidtion
		
		--q<=r_reg;
		data_out<=xor1_out xor data_in;
		
end randomizer_arch;	
