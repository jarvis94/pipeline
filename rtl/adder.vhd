library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity adder is
    Port (A, B : in std_logic_vector(15 downto 0);
          output    : out std_logic_vector(15 downto 0));
    End;

Architecture behav of adder is
    begin

    	output <= std_logic_vector(unsigned(A) +unsigned(B)) ;
    
    end;
