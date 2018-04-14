--AND gate -3 inputs 
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;        -- for addition & counting
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;               -- for type conversions
--use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions



entity AND_gate3 is
	port ( 	A, B ,C  	:in std_logic;
		  	ANDout	:out std_logic);
end AND_gate3;

architecture behav of AND_gate3 is

begin
	
	ANDout<=A and B and C;

end behav;