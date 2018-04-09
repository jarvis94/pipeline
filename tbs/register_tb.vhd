library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_tb is
end register_tb ;

architecture arc of register_tb  is

signal input,output :std_logic_vector(15 downto 0);
signal clk, rst : std_logic;

begin
    dut_and_2: entity work.register_w(behav) generic map(16) port map(input,clk,rst,output);

Cl :process -- create free-running test clock
    begin
        clk <= '0'; wait for 5 ns;       -- clock cycle 10 ns
          clk <= '1'; wait for 5 ns;
    end process;

stimulus:process
    begin
        rst<='0';
        input<=std_logic_vector (to_unsigned (1001,16));
        
        wait for 2 ns;
        
        input<=std_logic_vector (to_unsigned (1301,16));
        
        wait for 12 ns;
        
        input<= x"0F11";
        
        wait for 8 ns;
        
        input<= x"0FFA";
        
        wait for 15 ns;

        --wait;
    end process;
end arc;