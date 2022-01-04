library ieee;
use ieee.std_logic_1164.all;
entity interleaver is
	port(
		clk, reset, data_ready, enable, data_in: in std_logic;
		data_out,valid: out std_logic;
		output_buffer: out std_logic_vector(191 downto 0)
	);
end interleaver;
architecture interleaver_arch of interleaver is

   type interleaver_state_type is
        (idle, listening, interleaving,streaming);
   signal state_reg, state_next: interleaver_state_type;
	signal data_count: integer:=0;
	signal interleaver_count, streamer_count: integer:=0;
	signal data_buffer: std_logic_vector (191 downto 0);
	signal i,x: integer:=191;
	signal data_out_temp: std_logic;
	signal output_buffer_temp: std_logic_vector (191 downto 0);
	signal temp: std_logic;
	signal mk: integer:=0;
	
begin

   -- state register
   process(clk ,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
      elsif (rising_edge(clk)) then
         state_reg <= state_next;
      end if;
   end process;
   -- next-state logic and output logic
   process(state_reg, clk, reset)
   begin
         -- default values
     if(rising_edge(clk)) then
      case state_reg is
         when idle =>
				valid<='0';
				data_out_temp<='0';
				data_count<=0;
				interleaver_count<=0;
				data_buffer<=X"000000000000000000000000000000000000000000000000";
				output_buffer_temp<=X"000000000000000000000000000000000000000000000000";
--				streamer_count<=0;
--				i<=191;
--				x<=191;
-- 
				if(reset='0') then
					state_next<=listening;
				else
					state_next<=idle;
				end if;
			
				
         when listening =>
					valid<='0';
					data_out_temp<='0';

				if(data_ready='1' and data_count<192) then
					data_buffer<=  data_buffer(190 downto 0) & data_in;	
					
					data_count<=data_count+1;
				end if;
				
				if(data_count=192) then
					state_next<=interleaving;
				elsif (data_count>192) then
					state_next<=idle;
				else 
					state_next<=listening;
				end if;
			
			
         when interleaving =>
					valid<='0';
					
					data_out_temp<='0';
				
			  if(enable='1' and interleaver_count <192 ) then
					 	
					output_buffer_temp(mk)<=data_buffer(i);
					
					--data_out_temp<=output_buffer(i);
					
					if (interleaver_count>0) then
					i<=i-1;
					end if;
				
					interleaver_count<=interleaver_count+1;
					 
				else
	
					if(interleaver_count<192) then
						state_next<=interleaving;
					else
						state_next<=streaming;
					end if;
			 end if;	
			 
			 when streaming =>
					valid<='1';
					if(streamer_count <192 ) then
					
					 data_out_temp<=output_buffer_temp(x);
					
					if (streamer_count>-1) then
						x<=x-1;
					end if;
				
					streamer_count<=streamer_count+1;
					 
				else
	
					if(streamer_count<192) then
						state_next<=streaming;
					else
						state_next<=idle;
					end if;
			 end if;	
					
			 
	end case;
	
	
	end if;
	
   end process;


	mk<=(((i mod 16)*12) + i/16);
	data_out<=data_out_temp;
	output_buffer<=output_buffer_temp;
	
		

end interleaver_arch;


