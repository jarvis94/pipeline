--Register bank
--inputs:  RS1(3), RS2(3), WB_data(16),R7_data(16),RD(16)
--outputs: RegSource(16) ,RegSource(16)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity register_bank is
port (
		RS1,RS2,RD				:in std_logic_vector(3 downto 0);
		WB_data,R7_data 		:in std_logic_vector(15 downto 0);
		Reg_Wr_en,R7_Wr_en,clk	:in std_logic;
		RegSrc1,RegSrc2 		:out std_logic_vector(15 downto 0));
end register_bank;					

architecture behav of register_bank is


begin
postive_edge : process (clk)
begin
  if (clk'event and clk='1') then
  	if(RD)
  end if;
end process postive_edge;
end behav;

