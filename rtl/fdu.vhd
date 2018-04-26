--forwarding unit
-------------------------------------------------------------

-- inputs

-- exe_lw -- indicator lw in exe stage -- from rr_exe_pipe
-- rr_sw -- indicator sw in rr stage -- from id_rr_pipe
-- exe_stall_lm_sm -- lm_sm_stall -- from rr_exe_pipe
-- rr_exe_val -- validity of rr_exe -- from rr_exe_pipe
-- exe_mem_val -- validity of exe_mem -- from exe_mem_pipe
-- mem_wb_val -- validity of mem_wb -- from mem_wb_pipe
-- rr_rs_en -- indicator of source registers -- from id_rr_pipe
-- exe_rd -- destination reg in exe stage -- from rr_exe_pipe
-- mem_rd -- destination reg in mem stage -- from exe_mem_pipe
-- wb_rd -- destination reg in wb stage -- from mem_wb_pipe
-- rs2 -- source reg in rr stage -- from id_rr_pipe
-- rs1 -- source reg in rr stage -- from id_rr_pipe

--outputs

-- fwd_s1 -- forward mux select for source 1
-- fwd_s2 -- forward mux selece for source 2

--------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fdu is
	port (
		exe_lw,rr_sw,exe_stall_lm_sm,rr_exe_val,exe_mem_val,mem_wb_val : in std_logic;
		rr_rs_en: in std_logic_vector(1 downto 0);
		exe_rd,mem_rd,wb_rd,rs2,rs1: in std_logic_vector(2 downto 0);
		fwd_s1,fwd_s2: out std_logic_vector(2 downto 0)
	);
end fdu;

architecture fdu_arc of fdu is

signal fwd_s1_m,fwd_s2_m: std_logic_vector(2 downto 0);

begin

--process to detect data dependencies and compute forward logic
--priority of dependencies -> exe,mem,wb ; exe has the highest priority 
detect_match:process(exe_lw,rr_sw,exe_stall_lm_sm,rr_exe_val,exe_mem_val,mem_wb_val,
	rr_rs_en,exe_rd,mem_rd,wb_rd,rs2,rs1)
begin
	if (rr_rs_en = "11") then
		-- ignores data dependencies when exe_lw = 1
		if (exe_rd = rs1 and exe_rd = rs2 and exe_lw = '0' and rr_exe_val = '1') then
			fwd_s1_m <= "001";-- forward from exe out
			fwd_s2_m <= "001";		
		elsif (exe_rd = rs1 and exe_lw = '0' and rr_exe_val = '1') then
			fwd_s1_m <= "001";
			fwd_s2_m <= "000";
		elsif (exe_rd = rs2 and exe_lw = '0' and rr_exe_val = '1') then
			fwd_s1_m <= "000";
			fwd_s2_m <= "001";
		elsif (mem_rd = rs1 and mem_rd = rs2 and exe_mem_val = '1') then
			fwd_s1_m <= "010"; -- forward from mem out
			fwd_s2_m <= "010";
		elsif (mem_rd = rs1 and exe_mem_val = '1') then
			fwd_s1_m <= "010";
			fwd_s2_m <= "000";
		elsif (mem_rd = rs2 and exe_mem_val = '1') then
			fwd_s1_m <= "000"; 
			fwd_s2_m <= "010";
		elsif (wb_rd = rs1 and wb_rd = rs2 and mem_wb_val = '1') then
			fwd_s1_m <= "011";-- forward from wb out
			fwd_s2_m <= "011";
		elsif (wb_rd = rs1 and mem_wb_val = '1') then
			fwd_s1_m <= "011";
			fwd_s2_m <= "000";
		elsif (wb_rd = rs2 and mem_wb_val = '1') then
			fwd_s1_m <= "000";
			fwd_s2_m <= "011";
		elsif (rs1 = "111" and rs2 = "111") then
			fwd_s1_m <= "100";-- forward from rr pc
			fwd_s2_m <= "100";
		elsif (rs1 = "111") then
			fwd_s1_m <= "100";
			fwd_s2_m <= "000";
		elsif (rs2 = "111") then
			fwd_s1_m <= "000";
			fwd_s2_m <= "100";						
		else
			fwd_s1_m <= "000";-- no forwarding
			fwd_s2_m <= "000";			
		end if;
	elsif (rr_rs_en = "01") then
			fwd_s2_m <= "000";
		-- when exe_stall_lm_sm is 1 data dependcies are ignored
		--
		if (exe_rd = rs1 and exe_stall_lm_sm = '0' and rr_exe_val = '1') then
			fwd_s1_m <= "001";			
		elsif (mem_rd = rs1 and exe_stall_lm_sm = '0' and exe_mem_val = '1') then
			fwd_s1_m <= "010";
		elsif (wb_rd = rs1 and exe_stall_lm_sm = '0' and mem_wb_val = '1') then
			fwd_s1_m <= "011";
		elsif (rs1 = "111") then
			fwd_s1_m <= "100";
		else
			fwd_s1_m <= "000";			
		end if;
	elsif (rr_rs_en = "10") then
			fwd_s1_m <= "000";
		if (exe_rd = rs2 and rr_exe_val = '1') then
			fwd_s2_m <= "001";
		elsif (mem_rd = rs2 and exe_mem_val = '1') then
			fwd_s2_m <= "010";
		elsif (wb_rd = rs2 and mem_wb_val = '1') then
			fwd_s2_m <= "011";
		elsif (rs2 = "111") then
			fwd_s2_m <= "100";
		else
			fwd_s2_m <= "000";			
		end if;
	else
		fwd_s2_m <= "000";
		fwd_s1_m <= "000";
	end if;
end process;

--interchange rs1 and rs2 forwarding if rr instruction is sw
--else assign the previous computed value to output
detect_sw: process(rr_sw,fwd_s1_m,fwd_s2_m)
begin
	if(rr_sw = '1') then
		fwd_s2 <= fwd_s1_m;
		fwd_s1 <= fwd_s2_m;
	else
		fwd_s1 <= fwd_s1_m;
		fwd_s2 <= fwd_s2_m;
	end if; 
end process;
end fdu_arc;