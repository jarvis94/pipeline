library ieee;
use ieee.std_logic_1164.all;

entity and_2_tb is
end and_2_tb ;

architecture arc of and_2_tb  is

signal a,b,a_and_b : std_logic;

begin
	dut_and_2: entity work.AND_gate(behav) port map(a,b,a_and_b);

	stimulus:process
	begin
		a<='0';
    	b<='0';
    	wait for 5 ns;
    	a<='0';
    	b<='1';
    	wait for 5 ns;
    	a<='1';
    	b<='0';
    	wait for 5 ns;
    	a<='1';
    	b<='1';
    	wait for 5 ns;
    	wait;
    end process;
end arc;