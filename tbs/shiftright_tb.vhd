library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftright_tb is
end shiftright_tb ;

architecture arc of shiftright_tb  is

signal input,output :std_logic_vector(15 downto 0);


begin
    dut_and_2: entity work.shiftright(behav) generic map(16) port map(input,output);


stimulus:process
    begin
        input<=std_logic_vector (to_unsigned (1001,16));
        
        wait for 2 ns;
        
        input<=std_logic_vector (to_unsigned (1301,16));
        
        wait for 12 ns;
        
        input<= x"0F11";
        
        wait for 8 ns;
        
        input<= x"0FFA";
        
        wait for 15 ns;

        wait;
    end process;
end arc;