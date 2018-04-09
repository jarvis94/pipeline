library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb ;

architecture arc of alu_tb  is

signal a,b,add_res :std_logic_vector(15 downto 0);

begin
	dut_and_2: entity work.adder(behav) port map(a,b,add_res);

	stimulus:process
	begin
		
        a<=std_logic_vector (to_unsigned (1001,16));
        b<=std_logic_vector (to_unsigned (1,16));
        wait for 5 ns;
        a<= x"FFFA";
        b<= x"000F";
        
        wait for 5 ns;
        a<= x"11FF";
        b<= x"FF01";
        
        wait for 5 ns;

    	a<= x"1000";
    	b<= x"0001";
        
        wait for 5 ns;
    	--a<='1';
    	--b<='0';
    	--wait for 5 ns;
    	--a<='1';
    	--b<='1';
    	--wait for 5 ns;
    	wait;
    end process;
end arc;