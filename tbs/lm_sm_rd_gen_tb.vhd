library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity lm_sm_rd_gen_tb is
end lm_sm_rd_gen_tb;

architecture lm_sm_rd_gen_arc of lm_sm_rd_gen_tb is

	signal clk,mux_sel,val,rst,stall_1,stall_reg,lm_sm: std_logic;
	signal imm_81,mux_out,nxt_imm,nxt_imm_reg: std_logic_vector(7 downto 0 );
	signal rd_1,rd_reg: std_logic_vector(2 downto 0);

begin

dut:entity work.lm_sm_rd_gen(behave) port map(mux_out,rd_1,nxt_imm,stall_1,val,lm_sm);
mux1: entity work.mux(behav) port map(imm_81,nxt_imm_reg,mux_out,stall_reg);
rd_reg1: entity work.register_w(behav) generic map(3) port map(rd_1,clk,rst,rd_reg);
stall_reg1: entity work.register_1(behav) port map(stall_1,clk,rst,stall_reg);
nxt_imm_reg1: entity work.register_w(behav) generic map(8) port map(nxt_imm,clk,rst,nxt_imm_reg);

Cl :process -- create free-running test clock
    begin
        clk <= '0'; wait for 5 ns;       -- clock cycle 10 ns
        clk <= '1'; wait for 5 ns;
    end process;
stimulus: process
begin
	rst <= '1';
	val <= '0';
	lm_sm <= '1';
	imm_81 <= x"FF";
	wait for 10 ns;

	rst <= '0';
	val <= '1';
	lm_sm <= '1';	
	imm_81 <= x"FF";
	wait for 80 ns;
	
	rst <= '0';
	val <= '1';
	lm_sm <= '1';
	imm_81 <= x"01";
	wait for 30 ns;
	
	rst <= '0';
	val <= '0';
	lm_sm <= '1'; 
	imm_81 <= x"FF";
	wait for 30 ns;
	
	rst <= '0';
	val <= '1';
	lm_sm <= '0';
	imm_81 <= x"FF";
	wait for 30 ns;

	wait;
end process;
end lm_sm_rd_gen_arc;