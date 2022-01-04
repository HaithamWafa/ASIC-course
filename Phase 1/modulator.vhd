library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity modulator is
	port(
		clk, reset, data_ready, data_in: in std_logic;
		valid: out std_logic;
		NConstMap0, NConstMap1: out integer
	);
end modulator;
architecture modulator_arch of modulator is

	signal data_count: integer:=-1;
	--signal buffered_bit: std_logic;
	signal temp: std_logic_vector(1 downto 0);
	signal ConstMap1, ConstMap0: integer;
	signal Nconstant: std_logic_vector(15 downto 0);
begin
  
   process(clk, reset)
   begin
         
     if(rising_edge(clk)) then
			if( reset= '1') then
				ConstMap0<=0;
				ConstMap1<=0;	
				valid<='0';
				data_count<=-1;
			elsif (data_ready='1') then
					
					--buffered_bit<=data_in;
					--temp<='0' & data_in & buffered_bit;
					temp<=temp(0) & data_in;
					data_count<=data_count+1;
					if(data_count=1) then 
						data_count<=0;
						case temp is
				
							when "00" =>
								ConstMap0<=1;
								ConstMap1<=1;
								valid<='1';
						
							when "01" =>
								ConstMap0<=-1;
								ConstMap1<=1;
								valid<='1';
						
							when "11" =>
								ConstMap0<=-1;
								ConstMap1<=-1;
								valid<='1';
						
							when "10" =>
								ConstMap0<=1;
								ConstMap1<=-1;
								valid<='1';
						
							when others =>
								ConstMap0<=0;
								ConstMap1<=0;
								valid<='0';
						end case;
					else 
						ConstMap0<=0;
						ConstMap1<=0;	
						valid<='0';
						
				end if;
	
			else 
					ConstMap0<=0;
					ConstMap1<=0;	
					valid<='0';
				
		
			end if;
	
	end if;
	
   end process;

	Nconstant<=X"5A7F";
	NConstMap0<=ConstMap0*to_integer(unsigned(Nconstant));
	NConstMap1<=ConstMap1*to_integer(unsigned(Nconstant));
	
		

end modulator_arch;


