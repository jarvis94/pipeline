--unit register
--Register bank
--inputs:  RS1(3), RS2(3), WB_data(16),R7_data(16),RD(16)
--outputs: RegSource(16) ,RegSource(16)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity register_w is
generic(W: integer:=16);
port (
    Wr_data     :in std_logic_vector(W-1 downto 0);
    clk,reset,wr_en   :in std_logic;
    Reg_data    :out std_logic_vector(W-1 downto 0));
end register_w;         

architecture behav of register_w is

begin
postive_edge : process (clk)
begin
  if (clk'event and clk='1') then
    
    if reset='1' then
		  --Reg_data <= x"0000";
        Reg_data <= std_logic_vector(to_unsigned(0,W));
   
    elsif (wr_en ='1') then
        Reg_data <=Wr_data;
    end if;
    
  end if;
  
end process postive_edge;
end behav;

