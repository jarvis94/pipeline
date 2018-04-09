library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux is
	port (
		mux_in1,mux_in2 : in std_logic_vector(7 downto 0);
		mux_out: out std_logic_vector(7 downto 0);
		mux_sel: in std_logic
	);
end mux;
architecture behav of mux is
begin
	with mux_sel select 
	mux_out <= mux_in1 when '0',
			   mux_in2 when '1',
			   (others => '0') when others;
end behav;