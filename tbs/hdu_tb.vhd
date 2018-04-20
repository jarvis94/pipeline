library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity hdu_tb is
end hdu_tb;


architecture hdu_test_arc of hdu_tb is

	signal wr_en_reg_t,rr_exe_load_t,id_rr_beq_t,
	comp_out_t,id_rr_jlr_t,id_jal_t,id_stall_lm_sm_t,rr_exe_val_t,id_rr_val_t: std_logic;
	signal wb_rd_t: std_logic_vector(2 downto 0);
	signal rr_rs_en_t: std_logic_vector(1 downto 0);
	signal rr_src1_t,rr_src2_t,exe_rd_t: std_logic_vector(2 downto 0);
	signal flush_pipe_b_t: std_logic_vector(4 downto 0);
	signal stall_pipe_b_t: std_logic_vector(4 downto 0);
	signal r7_we_t,br_taken_t,tmp_pc_we_t: std_logic;
	signal jal_br_t:std_logic;
	signal nxt_pc_sel_t: std_logic_vector(1 downto 0);

	signal rd_bits_t: std_logic_vector(3 downto 0);
	signal load_bits_t: std_logic_vector(3 downto 0);
	signal beq_bits_t: std_logic_vector(2 downto 0);
	signal jump_bits_t: std_logic_vector(2 downto 0);
--signal load_bits_ex: std_logic_vector(1 downto 0);
	signal stall_t: std_logic;
begin
   uut: entity work.hdu(hdu_arc) port map (
   		wr_en_reg_t,rr_exe_load_t,id_rr_beq_t,comp_out_t,id_rr_jlr_t,id_jal_t,id_stall_lm_sm_t,rr_exe_val_t,id_rr_val_t,
		wb_rd_t,rr_rs_en_t,rr_src1_t,rr_src2_t,exe_rd_t,flush_pipe_b_t,stall_pipe_b_t,r7_we_t,br_taken_t,tmp_pc_we_t,
		jal_br_t,nxt_pc_sel_t);

	(wr_en_reg_t, wb_rd_t(2),wb_rd_t(1),wb_rd_t(0)) <= rd_bits_t;
	(rr_exe_load_t,rr_rs_en_t(1),rr_rs_en_t(0),rr_exe_val_t) <= load_bits_t;
	(id_rr_beq_t,comp_out_t,id_rr_val_t) <= beq_bits_t;
	(id_rr_jlr_t, id_jal_t,id_rr_val_t) <= jump_bits_t;
	id_stall_lm_sm_t <= stall_t; 
 	stimulus: process
 	begin
 		rd_bits_t <= "0000";
 		load_bits_t <= "0000";
 		beq_bits_t <= "000";
 		jump_bits_t <= "000";
 		stall_t <= '0';
 		wait for 10 ns;
 		rd_bits_t <= "1111";
 		load_bits_t <= "1011";
 		wait for 10 ns;

 		rd_bits_t <= "0000";
 		load_bits_t <= "1011";
 		wait for 10 ns;
 		load_bits_t <= "1110";
 		wait for 10 ns;
 		load_bits_t <= "1001";
 		beq_bits_t <= "111";
 		jump_bits_t <= "101";
 		wait for 10 ns;
 		load_bits_t <= "1001";
 		beq_bits_t <= "001";
 		jump_bits_t <= "101";
 		wait for 10 ns;
 		wait;
 	end process;
end hdu_test_arc;