--unit register
--Register bank
--inputs:  RS1(3), RS2(3), WB_data(16),R7_data(16),RD(16)
--outputs: RegSource(16) ,RegSource(16)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity shiftright is
generic(W: integer:=16);
port (
    in_data     :in std_logic_vector(W-1 downto 0);
    out_data    :out std_logic_vector(W-1 downto 0));
end shiftright;         

architecture behav of shiftright is

begin
    out_data <= "0000000" & in_data(W-1 downto 7);
  

end behav;

