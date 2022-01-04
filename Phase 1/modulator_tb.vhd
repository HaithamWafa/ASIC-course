library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulator_tb is
end modulator_tb;


architecture tb_arch of modulator_tb is 
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
	reset <= '1'; 
	data_ready<='0';
	data_in<='1';
	wait for (period); 
	reset <= '0'; 
	wait for (period); 
	data_ready<='1';
	for i in 191 downto 0 loop
	data_in<=data(i);
	wait for (period);
               --begin modulation
	
	end loop;
	 wait;
	end process;

	
	--self-check verifier
--	process
--      variable test_pass: boolean:=true;
--   begin
--	wait for 37 ns;
--		for i in 95 downto 0 loop
--	
--			if ((data_out=data_out_expected(i)))
--      then
--         test_pass := true;
--      else
--         test_pass := false;
--      end if;
--		
--      -- error reporting
--      assert test_pass
--         report "test failed."
--         severity note;
--				wait for (period);
--		end loop;
--		wait;
--   end process;
--	
	
	
	
end tb_arch;
	
	