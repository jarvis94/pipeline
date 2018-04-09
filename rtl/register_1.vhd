library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity register_1 is 
port (
    Wr_data     :in std_logic;
    clk,reset   :in std_logic;
    Reg_data    :out std_logic);
end register_1;         

architecture behav of register_1 is

begin
postive_edge : process (clk)
begin
  if (clk'event and clk='1') then
    
    if reset='1' then
		  --Reg_data <= x"0000";
        Reg_data <= '0';    
    else
        Reg_data <=Wr_data;
    end if;
    
  end if;
  
end process postive_edge;
end behav;
