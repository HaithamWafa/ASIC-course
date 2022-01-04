library ieee,std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

package testing_package is
--procedure headers & constants used for randomizer self-checking
	procedure seed_randomizer(signal reset, data_ready, load, data_in: out std_logic;signal seed: out std_logic_vector(14 downto 0));
	procedure sample_RAND(signal data_in, data_ready: out std_logic);
	procedure evaluate_output(data_out: in std_logic; i: in integer);
	constant randIN_vector: std_logic_vector(95 downto 0):=X"ACBCD2114DAE1577C6DBF4C9";
	constant randOUT_vector : std_logic_vector(95 downto 0) := X"558AC4A53A1724E163AC2BF9";

	--procedure headers & constants used for FEC self-checking
   procedure FEC_init(signal reset, data_ready, enable, data_in: out std_logic); 
	procedure sample_FEC(signal data_in, enable: out std_logic);
	procedure FEC_eval(output_buffer: in std_logic_vector(191 downto 0));
	constant FECIN_vector: std_logic_vector(95 downto 0):=X"558AC4A53A1724E163AC2BF9";
	constant FECOUT_vector : std_logic_vector(191 downto 0) := X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
	
	--procedure headers & constants used for interleaver self-checking
   procedure interleaver_init(signal reset, data_ready, enable, data_in: out std_logic); 
	procedure sample_interleaver(signal data_in, enable: out std_logic);
	procedure interleaver_eval(output_buffer: in std_logic_vector(191 downto 0));
	constant interleaverIN_vector: std_logic_vector(191 downto 0):=X"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
	constant interleaverOUT_vector : std_logic_vector(191 downto 0) := X"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";
	
	--procedure headers & constants used for modulator self-checking
   procedure modulator_init(signal reset, data_ready, data_in: out std_logic); 
	procedure sample_modulator(signal data_in: out std_logic);
	procedure modulator_eval(NConstMap1, NConstMap0: in integer; signal valid: in std_logic);
	constant modIN_vector: std_logic_vector(191 downto 0):=X"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";
	
	
	constant pos_707 : std_logic_vector (15 downto 0) := "0101101001111111";
	constant neg_707 : std_logic_vector (15 downto 0) := "1010010110000001";
	
	constant period: time:= 10 ns;
	
end package testing_package;

package body testing_package is

procedure seed_randomizer(signal reset, data_ready, load, data_in: out std_logic; signal seed: out std_logic_vector(14 downto 0))  is 
begin

	reset <= '1'; 
	seed<="011011100010101";    --initial seed loading
	data_ready<='0';
	load<='1';
	data_in<='1';
end seed_randomizer;

procedure sample_RAND(signal data_in, data_ready: out std_logic) is 
begin
for i in 95 downto 0 loop
	data_in<=randIN_vector(i);
	wait for (period);
	data_ready<='1';               --begin encoding
	
	end loop;
	 wait;
end sample_RAND;

procedure evaluate_output (data_out: in std_logic; i: in integer) is 

variable test_pass: boolean;
begin
	
	
			if ((data_out=randOUT_vector(i)))
      then
         test_pass := true;
      else
         test_pass := false;
      end if;
      -- error reporting
      assert test_pass
         report "test failed."
         severity note;
				wait for (period);
		

end evaluate_output;
 procedure FEC_init(signal reset, data_ready, enable, data_in: out std_logic) is
begin
	
	reset <= '1'; 
	data_ready<='0';
	enable<='0';
	data_in<='1';

end FEC_init; 

procedure sample_FEC(signal data_in, enable: out std_logic) is

begin

for i in 95 downto 0 loop
	data_in<=FECIN_vector(i);
	wait for (period);
	enable<='1';               --begin encoding
	
	end loop;
	 wait;



end sample_FEC;

procedure FEC_eval(output_buffer: in std_logic_vector(191 downto 0)) is 

variable test_pass: boolean;
begin
	
	
			if (output_buffer=FECOUT_vector) then
         test_pass := true;
      else
         test_pass := false;
      end if;
      -- error reporting
      assert test_pass
         report "test failed."
         severity note;
				wait for (period);
				wait;

end FEC_eval;
procedure interleaver_init(signal reset, data_ready, enable, data_in: out std_logic) is
begin
	
	reset <= '1'; 
	data_ready<='0';
	enable<='0';
	data_in<='1';

end interleaver_init; 

procedure sample_interleaver(signal data_in, enable: out std_logic) is

begin

for i in 191 downto 0 loop
	data_in<=interleaverIN_vector(i);
	wait for (period);
	enable<='1';               --begin interleaving
	
	end loop;
	 wait;
end sample_interleaver;

procedure interleaver_eval(output_buffer: in std_logic_vector(191 downto 0)) is 

variable test_pass: boolean;
begin
	
	
			if (output_buffer=interleaverOUT_vector) then
         test_pass := true;
      else
         test_pass := false;
      end if;
      -- error reporting
      assert test_pass
         report "test failed."
         severity note;
				wait for (period);
				wait;

end interleaver_eval;


procedure modulator_init(signal reset, data_ready, data_in: out std_logic) is
begin
	
	reset <= '1'; 
	data_ready<='0';
	data_in<='1';

end modulator_init; 

procedure sample_modulator(signal data_in: out std_logic) is

begin

for i in 191 downto 0 loop
	data_in<=modIN_vector(i);
	wait for (period);
	
	end loop;
	 wait;
end sample_modulator;

procedure modulator_eval(NConstMap1, NConstMap0: in integer; signal valid: in std_logic) is 
		file in_file		: text open read_mode is "in_values.txt";
		variable in_line 	: line ;
		variable bit1,bit0: integer;
      variable test_pass: boolean:=true;
   begin
		while not endfile(in_file) loop
			readline(in_file, in_line);
			read(in_line,bit1);
			read(in_line,bit0);

	wait on valid;
		
	
			if ((NConstMap1=bit1) and (NConstMap0 = bit0))
      then
         test_pass := true;
      else
         test_pass := false;
      end if;
		
      -- error reporting
      assert test_pass
         report "test failed."
         severity note;
				wait for (period);
		end loop;
		wait;
end modulator_eval;



end package body testing_package;

