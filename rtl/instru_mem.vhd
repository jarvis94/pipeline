library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity instru_mem is 
	port ( 
			addr  	:in std_logic_vector(15 downto 0);
			instr 	:out std_logic_vector(15 downto 0));
end instru_mem;

architecture behav of instru_mem is

begin
	
process(addr)
begin

	case(addr) is
				
		when b"0000_0000_0000_0000"=>instr<="0011001000000001"; --LHI r1,1
		when b"0000_0000_0000_0001"=>instr<="0100000010000001"; --LW r0,r2,1
		when b"0000_0000_0000_0010"=>instr<="0000000000111000"; --ADD r7,r0,r0
		when b"0000_0000_0000_0011"=>instr<="1001010001000000"; --JLR r2,r1
		
		when others => instr<="----------------";
	end case;
end process;	
end behav;

