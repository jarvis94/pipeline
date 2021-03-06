-- hazard detection unit
--------------------------------------
--inputs

-- wr_en_reg -- from wb stage
-- rr_exe_load -- from rr_exe pipe
-- id_rr_beq -- from id_rr pipe
-- comp_out -- comparator output from rr stage
-- id_rr_jlr -- from id_rr pipe
-- id_jal -- from controller
-- id_stall_lm_sm -- from lm_sm_rd_gen
-- rr_exe_val -- validity of rr_exe pipe
-- id_rr_val -- validity of id_rr pipe
-- wb_rd -- from wb pipe
-- rr_rs_en -- number of source registers in id_rr pipe
-- rr_src1 -- source 1 address in rr stage
-- rr_src2 -- source 2 address in rr stage
-- exe_rd -- destination address in exe stage

-- outputs

-- flush_pipe_b -> 5 bits --MSB corresponds to if/id pipeline register valid bit
-- stall_pipe_b -> 5 bits --write enables of all pipeline registers
-- r7_we -> select bit for writing to r7 ( write PC+1 or write back output)
-- br_jal_taken -> indication of whether branch is taken or not
-- jal_br -> select bits for jal_branch pc mux
-- nxt_pc_sel -> select bits for next pc


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hdu is
	port (
		wr_en_reg,rr_exe_load,id_rr_beq,comp_out,id_rr_jlr,id_jal,id_stall_lm_sm,rr_exe_val,id_rr_val: in std_logic;
		wb_rd: in std_logic_vector(2 downto 0);
		rr_rs_en : in std_logic_vector(1 downto 0);
		rr_src1,rr_src2,exe_rd: in std_logic_vector(2 downto 0);
		flush_pipe_b: out std_logic_vector(4 downto 0);
		stall_pipe_b: out std_logic_vector(4 downto 0);
		r7_we,br_jal_taken,tmp_pc_we,jal_br: out std_logic;
		nxt_pc_sel: out std_logic_vector(1 downto 0)
	);
end hdu;

architecture hdu_arc of hdu is

signal rd_bits: std_logic_vector(3 downto 0);
signal load_bits: std_logic_vector(3 downto 0);
signal beq_bits: std_logic_vector(2 downto 0);
signal jump_bits: std_logic_vector(2 downto 0);
--signal load_bits_ex: std_logic_vector(1 downto 0);
signal stall: std_logic;
begin

rd_bits <= wr_en_reg & wb_rd;
load_bits <= rr_exe_load & rr_rs_en & rr_exe_val;
--load_bits_ex <= (rr_exe_load,stall)
beq_bits <= id_rr_beq & comp_out & id_rr_val;
jump_bits <= id_rr_jlr & id_jal & id_rr_val;
stall <= id_stall_lm_sm; 
detect_hazard: process(rd_bits,load_bits,beq_bits,jump_bits,stall)
begin
	if (rd_bits = "1111") then -- r7 hazard
		-- flush all stages
		flush_pipe_b <= "00000";
		stall_pipe_b <= "11111";
		tmp_pc_we <= '1';
		-- correct next pc so that it points to r7
		nxt_pc_sel <= "00";
		br_jal_taken <= '0';
		r7_we <= '1';
		jal_br <= '0';
	elsif (load_bits = "1011") then -- load dependancy hazards
		--check source 1
		if (rr_src1 = exe_rd) then
			--flush exe stage and stall previous stage
			flush_pipe_b <= "11011";
			stall_pipe_b <= "00111";
			tmp_pc_we <= '1';
			--correct next pc
			nxt_pc_sel <= "10";
			br_jal_taken <= '0';
			r7_we <= '0';
			jal_br <= '0';
		end if;	
	elsif (load_bits = "1101") then 
		--check source 2
		if (rr_src1 = exe_rd) then
			flush_pipe_b <= "11011";
			stall_pipe_b <= "00111";
			tmp_pc_we <= '1';
			nxt_pc_sel <= "10";
			br_jal_taken <= '0';
			r7_we <= '0';
			jal_br <= '0';
		end if;
	elsif (load_bits = "1111") then
		-- check both
		if (rr_src1 = exe_rd or rr_src2 = exe_rd) then
			flush_pipe_b <= "11011";
			stall_pipe_b <= "00111";
			tmp_pc_we <= '1';
			nxt_pc_sel <= "10";
			br_jal_taken <= '0';
			r7_we <= '0';
			jal_br <= '0';	
		end if;
	elsif (beq_bits = "111") then -- branch taken hazard
		-- flush stages before rr
		flush_pipe_b <= "00111";
		stall_pipe_b <= "11111";
		tmp_pc_we <= '1';
		-- correct nxt pc
		nxt_pc_sel <= "10";
		br_jal_taken <= '1';
		r7_we <= '0';
		jal_br <= '1';
	elsif (jump_bits = "101") then -- jlr hazard/pc correction
		-- flush stages before rr, correct nxt pc
		flush_pipe_b <= "00111";
		stall_pipe_b <= "11111";
		tmp_pc_we <= '1';
		nxt_pc_sel <= "01";
		br_jal_taken <= '0';
		r7_we <= '0';
		jal_br <= '0';
	elsif (jump_bits = "011") then -- jal pc correction
		flush_pipe_b <= "11111";
		stall_pipe_b <= "11111";
		tmp_pc_we <= '1';
		-- correct next pc
		nxt_pc_sel <= "01";
		br_jal_taken <= '1';
		r7_we <= '0';
		jal_br <= '0';
	elsif (stall = '1') then -- lm sm hazard
		flush_pipe_b <= "11111";
		-- stall
		stall_pipe_b <= "01111";
		tmp_pc_we <= '0';
		nxt_pc_sel <= "10";
		br_jal_taken <= '0';
		r7_we <= '0';
		jal_br <= '0';
	else
		-- default output
		flush_pipe_b <= "11111";
		stall_pipe_b <= "11111";
		tmp_pc_we <= '1';
		nxt_pc_sel <= "10";
		br_jal_taken <= '0';
		r7_we <= '0';
		jal_br <= '0';																																																																																																																																																																																																																																																																																																																																																																																																																																																			
	end if;
end process;

end hdu_arc;

