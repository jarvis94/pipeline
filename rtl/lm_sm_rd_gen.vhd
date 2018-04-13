-- Load multiple Destination generator
----------------------------------------
--inputs imm_8 8 bit --> from if/id.imm
--		 if_id_val   --> validity of if/id pipeline reg
--		 id_lm_sm    --> from control decoder indication of the decoded instruction being lm/sm 
--outputs rd        --> decoded destination/source address
--		  stall     --> to hazard detector
--        imm_8_fb  --> corrected imm_8 for next decoding
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lm_sm_rd_gen is
	port (
		imm_8 : in std_logic_vector(7 downto 0);
		rd: out std_logic_vector(2 downto 0);
		imm_8_fb: out std_logic_vector(7 downto 0);
		stall: out std_logic;
		if_id_val,id_lm_sm: in std_logic);
end lm_sm_rd_gen;

architecture behave of lm_sm_rd_gen is
signal decode_out,imm_8_fb_sig : std_logic_vector(7 downto 0);
signal rd_sig: std_logic_vector(2 downto 0);
begin

-- least priority encoder
least_prority_encoder_proc: process (imm_8)
begin
	if (imm_8(0) = '1') then
		rd_sig <= "000";
	elsif (imm_8(1) = '1') then
		rd_sig <= "001";
	elsif (imm_8(2) = '1') then
		rd_sig <= "010";
	elsif (imm_8(3) = '1') then
		rd_sig <= "011";
	elsif (imm_8(4) = '1') then
		rd_sig <= "100";
	elsif (imm_8(5) = '1') then
		rd_sig <= "101";
	elsif (imm_8(6) = '1') then
		rd_sig <= "110";
	elsif (imm_8(7) = '1') then
		rd_sig <= "111";
	else
		rd_sig <= "000";
	end if;
end process;

rd <= rd_sig;					
-- negated decode output
with rd_sig select 
	decode_out <= "11111110" when "000",
 				  "11111100" when "001",
 				  "11111000" when "010",
 				  "11110000" when "011",
 				  "11100000" when "100",
 				  "11000000" when "101",
 				  "10000000" when "110",
 				  "00000000" when "111",
 				  "00000000" when others;

-- next value to be fed back to the generator
imm_8_fb_sig <= imm_8 and decode_out;
imm_8_fb <= imm_8_fb_sig;
-- stall process
stall_proc: process(imm_8_fb_sig,if_id_val,id_lm_sm)
variable fb_var: std_logic;
begin
	fb_var := imm_8_fb_sig(0);
	for i in 0 to 6 loop
		fb_var := fb_var or imm_8_fb_sig(i+1);
	end loop;
	stall <= fb_var and if_id_val and id_lm_sm;
end process;		
end behave;