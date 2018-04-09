library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb ;

architecture arc of alu_tb  is

signal a,b,alu_res :std_logic_vector(15 downto 0);
signal alu_control,zero,carry : std_logic;

begin
	dut_and_2: entity work.ALU(RTL) generic map(16) port map(a,b,alu_control,alu_res,zero,carry);

	stimulus:process
	begin
		
        a<=std_logic_vector (to_unsigned (1001,16));
        b<=std_logic_vector (to_unsigned (1,16));
        alu_control<='1';
        wait for 5 ns;
        a<= x"FFFA";
        b<= x"000F";
        
        alu_control<='1';
        wait for 5 ns;
        a<= x"11FF";
        b<= x"FF01";
        
        alu_control<='0';
        wait for 5 ns;

    	a<= x"1000";
    	b<= x"0001";
        
        alu_control<='0';
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