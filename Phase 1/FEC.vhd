library ieee;
use ieee.std_logic_1164.all;
entity FEC is
	port(
		clk1, clk2, reset, data_ready, enable, data_in: in std_logic;
		X,Y,valid: out std_logic;
		output_buffer: out std_logic_vector (191 downto 0)
	);
end FEC;
architecture FEC_arch of FEC is

   type FEC_state_type is
        (idle, listening, initializing, encoding);
	signal r_reg: std_logic_vector(5 downto 0);
	signal r_next: std_logic_vector(5 downto 0);	  
   signal state_reg, state_next: FEC_state_type;
	signal data_count: integer:=0;
	signal encoder_count: integer;
	signal data_buffer: std_logic_vector (95 downto 0);
	signal temp: std_logic_vector (5 downto 0);
	signal i: integer:=95;
	signal output_buffer_temp: std_logic_vector (191 downto 0);
	signal X_temp, Y_temp: std_logic;
	
	
begin

   process(clk1 ,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
      elsif (rising_edge(clk1)) then
         state_reg <= state_next;
      end if;
   end process;
   -- next-state logic and output logic
   process(state_reg, clk1, reset)
   begin
         -- default values
    
	  
		if(reset='1') then
			r_reg<=(others=>'0');
			
		elsif(rising_edge(clk1)) then
			r_reg<=r_next;
		
			case state_reg is
				when idle =>
				data_count<=0;
				encoder_count<=0;
				data_buffer<=X"000000000000000000000000";
				output_buffer_temp<=X"000000000000000000000000000000000000000000000000";
				valid<='0';
				r_next<=(others=>'0');
	 
				if(reset='0') then
					
				state_next<=listening;
				else
				
				state_next<=idle;
				
				end if;
					
				when listening =>
						valid<='0';
					r_next<=(others=>'0');
				if(data_ready='1' and data_count<96) then
					data_buffer<=  data_buffer(94 downto 0) & data_in;
					
					data_count<=data_count+1;
				

				end if;
				if(data_count=96) then
				state_next<=initializing;
				elsif (data_count>96) then
				 state_next<=idle;
				else 
				state_next<=listening;
				end if;
				
				when initializing =>
							valid<='0';
						r_next<=data_buffer(0) & data_buffer(1) & data_buffer(2) & data_buffer(3) & data_buffer(4) & data_buffer(5) ;
						
						state_next<=encoding;
				
				when encoding =>
				
						if(encoder_count>0) then
								output_buffer_temp<=output_buffer_temp(189 downto 0) & X_temp & Y_temp;
								valid<='1';
						else
									valid<='0';
						end if;
						if(enable='1' and encoder_count <96 ) then
								r_next<=temp;
		
								if(encoder_count<96) then
									if(encoder_count>0) then
											i<=i-1;
									end if;
									encoder_count<=encoder_count+1;
					
								end if;		 
						else
								r_next<=r_reg;
								if(encoder_count<96) then
									state_next<=encoding;
								else
									state_next<=idle;
								end if;
						end if;	
			 
		end case;
	
	end if;
	
   end process;

	
	with(encoder_count) select
	   temp<=
		r_reg when 0,
		data_buffer(i) & r_next(5 downto 1) when others;
		
	--q<=r_reg;
	X_temp<=data_buffer(i) xor r_next(0) xor r_next(3) xor r_next(4) xor r_next(5);
	Y_temp<=data_buffer(i) xor r_next(0) xor r_next(1) xor r_next(3) xor r_next(4);
	X<=X_temp;
	Y<=Y_temp;
	output_buffer<=output_buffer_temp;
end FEC_arch;


