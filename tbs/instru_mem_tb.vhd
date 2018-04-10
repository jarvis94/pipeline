library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instru_mem_tb is
end instru_mem_tb ;

architecture arc of instru_mem_tb  is

signal  inp,op :std_logic_vector(15 downto 0);

begin
	dut_and_2: entity work.instru_mem(behav)  port map(inp,op);

	stimulus:process
    begin
    	inp<=b"0000_0000_0000_0000";
    	wait for 15 ns;
    	inp<=b"0000_0000_0000_0001";
    	wait for 15 ns;
        inp<=b"0000_0000_0000_0010";
    	wait for 15 ns;
        inp<=b"0000_0000_0000_0011";
    	wait for 15 ns;
        
        --wait for 15 ns;

        wait;
    end process;
end arc;