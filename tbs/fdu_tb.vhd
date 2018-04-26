library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fdu_tb is
end fdu_tb;
architecture fdu_tb_arc of fdu_tb is

signal	exe_lw_t,rr_sw_t,exe_stall_lm_sm_t,rr_exe_val_t,exe_mem_val_t,mem_wb_val_t : std_logic;
signal	rr_rs_en_t: std_logic_vector(1 downto 0);
signal	exe_rd_t,mem_rd_t,wb_rd_t,rs2_t,rs1_t: std_logic_vector(2 downto 0);
signal	fwd_s1_t,fwd_s2_t: std_logic_vector(2 downto 0);
begin
uut: entity work.fdu(fdu_arc) port map(
		exe_lw_t,rr_sw_t,exe_stall_lm_sm_t,rr_exe_val_t,exe_mem_val_t,mem_wb_val_t,rr_rs_en_t,
		exe_rd_t,mem_rd_t,wb_rd_t,rs2_t,rs1_t,fwd_s1_t,fwd_s2_t
		);
stimulus: process
begin
	exe_lw_t <= '0';
	rr_sw_t <= '0';
	exe_stall_lm_sm_t <= '0';
	rr_rs_en_t <= "11";
	rr_exe_val_t <= '1';
	exe_mem_val_t <= '1';
	mem_wb_val_t <= '1';
	rs1_t <= "011";
	rs2_t <= "011";
	exe_rd_t <= "011";
	mem_rd_t <= "011";
	wb_rd_t <= "011";
	wait for 10 ns;
	rr_exe_val_t <= '0';
	wait for 10 ns;
	rr_rs_en_t <= "01";
	wait for 10 ns;
	exe_stall_lm_sm_t <= '1';
	wait for 10 ns;
	rr_rs_en_t <= "10";
	wait for 10 ns;
	rs2_t <= "111";
	wait for 10 ns;
	rr_sw_t <= '1';
	wait for 10 ns;
	rr_sw_t <= '0';
	wait;
end process;
end fdu_tb_arc;
