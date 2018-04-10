library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity instru_mem is 
	port ( 
			addr ,Wr_data 	:in std_logic_vector(15 downto 0);
			instr 			:out std_logic_vector(15 downto 0);
			Wr_en,clk		:in std_logic);
end instru_mem;

architecture behav of instru_mem is

	type register_vector is array (65536 downto 0) of std_logic_vector(15 downto 0);
	signal rf : register_vector:= (others => x"0000");

begin

	process (addr,clk)
		variable wr_addr : integer;
    	
        begin
        	wr_addr := to_integer(unsigned(addr));
			
			if(addr'event ) then
		    	
		    	instr <= rf(wr_addr);
            
            end if;

  			if (clk'event and clk='1') then
  				if  Wr_en='1' then
				  	
				  	rf(wr_addr)<=Wr_data after 1 ps;

  				end if;
 			end if;

	end process ;
	
end behav;