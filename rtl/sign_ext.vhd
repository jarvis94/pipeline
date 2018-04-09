--sign extender 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity sign_ext is
generic(In_W: integer:=9;
		OUT_W: integer:=16);
port (
    in_data     :in std_logic_vector(In_W-1 downto 0);
    out_data    :out std_logic_vector(Out_W-1 downto 0));
end sign_ext;         

architecture behav of sign_ext is

begin
    out_data <= std_logic_vector(to_unsigned(0,Out_W-In_W)) & in_data(In_W-1 downto 0);
  

end behav;

