--AND gate 
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;        -- for addition & counting
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;               -- for type conversions
--use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions



entity AND_gate is
	port ( 	A, B  	:in std_logic;
		  	ANDout	:out std_logic);
end AND_gate;

architecture behav of AND_gate is

begin
	ANDout<=A and B;

end behav;