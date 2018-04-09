library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_ext_tb is
end sign_ext_tb ;

architecture arc of sign_ext_tb  is

signal input : std_logic_vector(8 downto 0); 
signal output :std_logic_vector(15 downto 0);


begin
    dut_and_2: entity work.sign_ext(behav) generic map(9,16) port map(input,output);


stimulus:process
    begin
        input<=std_logic_vector (to_unsigned (101,9));
        
        wait for 2 ns;
        
        input<=std_logic_vector (to_unsigned (301,9));
        
        wait for 12 ns;
        
        --input<= x"0F11";
        
        --wait for 8 ns;
        
        --input<= x"0FFA";
        
        --wait for 15 ns;

        wait;
    end process;
end arc;