--DATAPATH FOR DECODER and REGISTER READ
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity datapath_MEMstage is
	port (
		--	PC_IF_w	 			:in std_logic_vector(15 downto 0);
		--	IW_IF_w				: in std_logic_vector(15 downto 0);
			clk_w				:in std_logic;
			WB_ctrl_MEM_o		: out std_logic_vector(4 downto 0);
    		fwd_s1						: in std_logic_vector(2 downto 0);
    		fwd_s2						: in std_logic_vector(2 downto 0);
    		reset 						:in std_logic
    	--	PC_data_sel_w						: in std_logic_vector(1 downto 0)
    		--instru_write_data,data_for_mem_write: in std_logic_vector(15 downto 0);
    		--initialise					: in std_logic
	    );

end datapath_MEMstage;

architecture behav of datapath_MEMstage is

	component adder 
    Port (A, B : in std_logic_vector(15 downto 0);
          output    : out std_logic_vector(15 downto 0));
	end component;
	for all :adder use entity work.adder(behav);

	component instru_mem  
	port ( 
			addr  	:in std_logic_vector(15 downto 0);
			instr 			:out std_logic_vector(15 downto 0)
		 );
			
	end component;
	for all :instru_mem use entity work.instru_mem(behav);


	component sign_ext
		generic(In_W: integer;
				OUT_W: integer);
		port (
	    	in_data     :in std_logic_vector(In_W-1 downto 0);
	    	out_data    :out std_logic_vector(Out_W-1 downto 0));
	end component;
	for signext9_16: sign_ext use entity work.sign_ext(behav) generic map(9,16);
	
	component control_decoder 
	    Port (
          opcode : in std_logic_vector(3 downto 0);
          CZ     : in std_logic_vector(1 downto 0);
          WB_C_Check,WB_Z_Check,WB_C_Wr ,WB_Z_Wr,WB_RegWr         : out std_logic;
          MEM_data_in_sel,MEM_addr_sel,MEM_RD_en,MEM_Wr_en,MEM_dat: out std_logic;
          EXE_scr1,EXE_scr2_1,EXE_scr2_2,EXE_scr2_3               : out std_logic;
          EXE_Oper,EXE_data,EXE_Memaddr,EXE_LW                    : out std_logic;
          RR_rs1_sel,RR_src1_sel,RR_jlr,RR_br,RR_Sw               : out std_logic;
          RR_scr2_sel,RR_Rs_en                                    : out std_logic_vector(1 downto 0);
          ID_Rd_sel                                               : out std_logic_vector(1 downto 0);
          ID_jal,ID_lm_sm                                         : out std_logic);

	end component;
	for contrl_dec: control_decoder use entity work.control_decoder(behav);

	component lm_sm_rd_gen 
		
		port (
			imm_8 : in std_logic_vector(7 downto 0);
			rd: out std_logic_vector(2 downto 0);
			imm_8_fb: out std_logic_vector(7 downto 0);
			stall: out std_logic;
			if_id_val: in std_logic);
	end component;
	for lmsm_rd: lm_sm_rd_gen use entity work.lm_sm_rd_gen(behave);

	component mux_4x1 
	generic (W: integer:=3);
	port (
		mux_in0,mux_in1,mux_in2,mux_in3: in std_logic_vector(W-1 downto 0);
		mux_out: out std_logic_vector(W-1 downto 0);
		mux_sel: in std_logic_vector(1 downto 0)
	);
	end component;
	for rd_sel_mux_4x1 :mux_4x1 use entity work.mux_4x1(behav) ;

	
	component mux_8x1 
	generic(W: integer:=3);
	port (
		mux_in0,mux_in1,mux_in2,mux_in3,mux_in4,mux_in5,mux_in6,mux_in7: in std_logic_vector(W-1 downto 0);
		mux_out: out std_logic_vector(W-1 downto 0);
		mux_sel: in std_logic_vector(2 downto 0)
	);
	end component;
	for all:mux_8x1 use entity work.mux_8x1(behav) ; 

	component mux_2x1
	generic(W: integer);
	port (
		mux_in1,mux_in2 : in std_logic_vector(W-1 downto 0);
		mux_out: out std_logic_vector(W-1 downto 0);
		mux_sel: in std_logic
		);
	end component;
	for all: mux_2x1 use entity work.mux_2x1(behav);

	component mux_2x1_1bit 
	port (
		mux_in1,mux_in2 : in std_logic;
		mux_out: out std_logic;
		mux_sel: in std_logic
	);
	end component;
	for all: mux_2x1_1bit use entity work.mux_2x1_1bit(behav);


	component register_w 
	generic(W: integer:=16);
	port (
	    Wr_data     :in std_logic_vector(W-1 downto 0);
	    clk,reset,wr_en   :in std_logic;
	    Reg_data    :out std_logic_vector(W-1 downto 0));
	end component;
	for all: register_w use entity work.register_w(behav);   
	--for tmp_next_PC_reg: register_w use entity work.register_w(behav_reset);      

	component regIF_ID is
    Generic(W : integer:=16);
    Port (instruction : in std_logic_vector(W-1 downto 0);
          pc          : in std_logic_vector(W-1 downto 0);
          val         : in std_logic;
          clk,wr_en   : in std_logic;
          instr_out   : out std_logic_vector(W-1 downto 0);
          pc_out      : out std_logic_vector(W-1 downto 0);
          val_out	  : out std_logic);
	end component;

	for regIFID: regIF_ID use entity work.regIF_ID(behav); 

	component regID_RR is
    Generic(W : integer:=16);
    Port (
          pc          : in std_logic_vector(W-1 downto 0);
          WB_C_Check,WB_Z_Check,WB_C_Wr,WB_Z_Wr,WB_RegWr          : in std_logic;
          MEM_data_in_sel,MEM_addr_sel,MEM_RD_en,MEM_Wr_en,MEM_dat: in std_logic;
          EXE_scr1,EXE_scr2_1,EXE_scr2_2,EXE_scr2_3               : in std_logic;
          EXE_Oper,EXE_data,EXE_Memaddr,EXE_LW                    : in std_logic;
          RR_rs1_sel,RR_src1_sel,RR_jlr,RR_br,RR_Sw               : in std_logic;
          RR_scr2_sel,RR_Rs_en                                    : in std_logic_vector(1 downto 0);
          instruction : in std_logic_vector(11 downto 0);
          imm9_7_s_exd: in std_logic_vector(W-1 downto 0);
          Rd_or_RS    : in std_logic_vector(2 downto 0);
          stall_lm_sm : in std_logic;
          val         : in std_logic;
          clk,wr_en   : in std_logic;
          pc_out      : out std_logic_vector(W-1 downto 0);
          WB_C_Check_o,WB_Z_Check_o,WB_C_Wr_o ,WB_Z_Wr_o,WB_RegWr_o         : out std_logic;
          MEM_data_in_sel_o,MEM_addr_sel_o,MEM_RD_en_o,MEM_Wr_en_o,MEM_dat_o: out std_logic;
          EXE_scr1_o,EXE_scr2_1_o,EXE_scr2_2_o,EXE_scr2_3_o                 : out std_logic;
          EXE_Oper_o,EXE_data_o,EXE_Memaddr_o,EXE_LW_o                      : out std_logic;
          RR_rs1_sel_o,RR_src1_sel_o,RR_jlr_o,RR_br_o,RR_Sw_o               : out std_logic;
          RR_scr2_sel_o,RR_Rs_en_o                                          : out std_logic_vector(1 downto 0);
          instr_out     : out std_logic_vector(11 downto 0);
          imm9_7_s_exd_o: out std_logic_vector(W-1 downto 0);
          Rd_or_RS_o    : out std_logic_vector(2 downto 0);
          stall_lm_sm_o : out std_logic;
          val_out       : out std_logic); 
	end component;
	--for regIDRR: regID_RR use entity work.regID_RR(behav); 

	component AND_gate 
		port ( 	A, B  	:in std_logic;
		  	ANDout	:out std_logic);
	end component;
	for all: AND_gate use entity work.AND_gate(behav);


	component AND_gate3
		port ( 	A, B ,C 	:in std_logic;
		  	ANDout	:out std_logic);
	end component;
	for and3_check_lmsmstall: AND_gate3 use entity work.AND_gate3(behav);

	component register_bank
		port (
		RS1,RS2,RD				:in std_logic_vector(2 downto 0);
		WB_data,R7_data 		:in std_logic_vector(15 downto 0);
		Reg_Wr_en,R7_Wr_en,clk	:in std_logic;
		RegSrc1,RegSrc2 		:out std_logic_vector(15 downto 0));
	end component ;
	for register_bank1: register_bank use entity work.register_bank(behav);

	component shiftleft is
	generic(W: integer:=16);
	port (
    	in_data     :in std_logic_vector(W-1 downto 0);
    	out_data    :out std_logic_vector(W-1 downto 0));
	end component;
	for shift_left_by_7: shiftleft use entity work.shiftleft(behav);

	component regRR_EXE
	Generic(W : integer);
    Port (
          WB_C_Check,WB_Z_Check,WB_C_Wr,WB_Z_Wr,WB_RegWr          : in std_logic;
          MEM_data_in_sel,MEM_addr_sel,MEM_RD_en,MEM_Wr_en,MEM_dat: in std_logic;
          EXE_scr1,EXE_scr2_1,EXE_scr2_2,EXE_scr2_3               : in std_logic;
          EXE_Oper,EXE_data,EXE_Memaddr,EXE_LW                    : in std_logic;
          pc            : in std_logic_vector(W-1 downto 0);
          Scr1,Scr2 	: in std_logic_vector(W-1 downto 0);
          Rd  			: in std_logic_vector(2 downto 0);
          imm6_sign_extd: in std_logic_vector(W-1 downto 0);
          stall_lm_sm   : in std_logic;
          val           : in std_logic;
          clk,wr_en     : in std_logic;
          WB_C_Check_o,WB_Z_Check_o,WB_C_Wr_o ,WB_Z_Wr_o,WB_RegWr_o         : out std_logic;
          MEM_data_in_sel_o,MEM_addr_sel_o,MEM_RD_en_o,MEM_Wr_en_o,MEM_dat_o: out std_logic;
          EXE_scr1_o,EXE_scr2_1_o,EXE_scr2_2_o,EXE_scr2_3_o                 : out std_logic;
          EXE_Oper_o,EXE_data_o,EXE_Memaddr_o,EXE_LW_o                      : out std_logic;
          pc_out            : out std_logic_vector(W-1 downto 0);
          Scr1_o,Scr2_o 	: out std_logic_vector(W-1 downto 0);
          Rd_o 				: out std_logic_vector(2 downto 0);
          imm6_sign_extd_o  : out std_logic_vector(W-1 downto 0);
          stall_lm_sm_o : out std_logic;
          val_out       : out std_logic);
	end component;
	for all : regRR_EXE use entity work.regRR_EXE(behav);


	component alu 
	Generic(W : natural := 16);
    port(SrcA           : in std_logic_vector(W-1 downto 0);
         SrcB           : in std_logic_vector(W-1 downto 0);
         AluOperation   : in std_logic;
         AluResult      : out std_logic_vector(W-1 downto 0);
         Zero           : out std_logic;
         CarryOut       : out std_logic);
	end component;
	for all : alu use entity work.alu(behav);

	component counter 
    port(
            clk,reset_bar 	: in std_logic;
            counter_o		: out std_logic_vector(2 downto 0));
	end component;
	for all : counter use entity work.counter(behav);

	component OR_gate3 
		port ( 	A, B ,C  	:in std_logic;
		  	ORout	:out std_logic);
	end component;
	for all :OR_gate3 use entity work.OR_gate3(behav);

	component NOR_gate 
	port ( 	A, B  	:in std_logic;
		  	ANDout	:out std_logic);
	end component;
	for all :NOR_gate use entity work.NOR_gate(behav);


	component regEXE_MEM 
    Generic(W : integer:=16);
    Port (
          pc            : in std_logic_vector(W-1 downto 0);
          WB_C_Wr,WB_Z_Wr,WB_RegWr,MEM_LW          : in std_logic;
          MEM_data_in_sel,MEM_addr_sel,MEM_RD_en,MEM_Wr_en,MEM_dat: in std_logic;
          memaddr_smdata: in std_logic_vector(W-1 downto 0);
          ALUres_imm9exd: in std_logic_vector(W-1 downto 0);
          Carry,Zero    : in std_logic;
          Rd            : in std_logic_vector(2 downto 0);
          stall_lm_sm   : in std_logic;
          val           : in std_logic;
          clk,wr_en     : in std_logic;
          pc_out          : out std_logic_vector(W-1 downto 0);
          WB_C_Wr_o ,WB_Z_Wr_o,WB_RegWr_o,MEM_LW_o         : out std_logic;
          MEM_data_in_sel_o,MEM_addr_sel_o,MEM_RD_en_o,MEM_Wr_en_o,MEM_dat_o: out std_logic;
          memaddr_smdata_o: out std_logic_vector(W-1 downto 0);
          ALUres_imm9exd_o: out std_logic_vector(W-1 downto 0);
          Carry_o,Zero_o  : out std_logic;
          Rd_o            : out std_logic_vector(2 downto 0);
          stall_lm_sm_o   : out std_logic;
          val_out         : out std_logic);
	end component; 
	for all : regEXE_MEM use entity work.regEXE_MEM(behav);

	component data_mem 
	port ( 
			addr,Wr_data  	:in std_logic_vector(15 downto 0);
			mem_data 		:out std_logic_vector(15 downto 0);
			Rd_en,Wr_en,clk	:in std_logic);
	end component;
	for all : data_mem use entity work.data_mem(behav);


	component regMEM_WB 
    Generic(W : integer:=16);
    Port (
          pc            : in std_logic_vector(W-1 downto 0);
          WB_C_Wr,WB_Z_Wr,WB_RegWr : in std_logic;
          WBdata        : in std_logic_vector(W-1 downto 0);
          Carry,Zero    : in std_logic;
          Rd            : in std_logic_vector(2 downto 0);
          stall_lm_sm   : in std_logic;
          val           : in std_logic;
          clk,wr_en     : in std_logic;
          pc_out          : out std_logic_vector(W-1 downto 0);
          WB_C_Wr_o ,WB_Z_Wr_o,WB_RegWr_o : out std_logic;
          WBdata_o        : out std_logic_vector(W-1 downto 0);
          Carry_o,Zero_o  : out std_logic;
          Rd_o            : out std_logic_vector(2 downto 0);
          stall_lm_sm_o   : out std_logic;
          val_out         : out std_logic);
	end component;
	for all : regMEM_WB use entity work.regMEM_WB(behav);

	component register_1  
	port (
    Wr_data     :in std_logic;
    clk,reset_wren   :in std_logic;
    Reg_data    :out std_logic);
	end component;
	for all : register_1 use entity work.register_1(behav_wr_en);

	component zero_detector
    Port (A: in std_logic_vector(15 downto 0);
          out1   : out std_logic);
	end component; 
	for all : zero_detector use entity work.zero_detector(behav);
	
	component comparator 
    Port (A, B : in std_logic_vector(15 downto 0);
          out1   : out std_logic);
	end component; 
	for all : comparator use entity work.comparator(behav);

	component hdu 
	port (
		wr_en_reg,rr_exe_load,id_rr_beq,comp_out,id_rr_jlr,id_jal,id_stall_lm_sm,rr_exe_val,id_rr_val: in std_logic;
		wb_rd: in std_logic_vector(2 downto 0);
		rr_rs_en : in std_logic_vector(1 downto 0);
		rr_src1,rr_src2,exe_rd: in std_logic_vector(2 downto 0);
		flush_pipe_b: out std_logic_vector(4 downto 0);
		stall_pipe_b: out std_logic_vector(4 downto 0);
		r7_we,br_jal_taken,jal_br,tmp_pc_we: out std_logic;
		nxt_pc_sel: out std_logic_vector(1 downto 0)
	);
	end component; 
	for all : hdu use entity work.hdu (hdu_arc);

	component nextR7data 
	port (
			Val_MEM,Val_EXE,Val_RR:in std_logic;
			next_R7data_sel :out std_logic_vector(1 downto 0)
			);
	end component;
	for all : nextR7data use entity work.nextR7data (behav);

	signal R7_Wr_en_w,Br_or_jal_taken_w,Tmp_PC_Wr_en_w :std_logic;
	signal PC_IF_w,IW_IF_w								:std_logic_vector(15 downto 0);
	signal nxt_pc_sel_w 	:std_logic_vector(1 downto 0);
	signal IW_ID_w, PC_ID_w,imm9signextd_ID_w	:std_logic_vector(15 downto 0);
	signal imm_8_in,imm_8_fb_w,imm_8_rego_w	    : std_logic_vector(7 downto 0);
	signal Val_ID_w,stall_lm_sm_ID_w,stall_lm_sm_w ,stall_lm_sm_RR_w		: std_logic; 
	signal WB_ctrl_ID_w,MEM_ctrl_ID_w   : std_logic_vector(4 downto 0);
    signal EXE_ctrl_ID_w              	: std_logic_vector(7 downto 0);
    signal RR_ctrl_ID_w               	: std_logic_vector(8 downto 0);
    signal Rd_sel_ID_w                  : std_logic_vector(1 downto 0);
    signal jal_ID_w ,lm_sm_ID_w         : std_logic;
    signal RD_lmsm_w,Rd_ID_w,Rd_WB_w	: std_logic_vector(2 downto 0);
    signal Val_ID_RR_w					:std_logic;	
    signal PC_RR_w,imm9signextd_RR_w	:std_logic_vector(15 downto 0);
    signal IW_RR_w						:std_logic_vector(11 downto 0);

	signal Val_RR_w,RegBank_Wr_en_w,equ_w	: std_logic; 
	signal WB_ctrl_RR_w,MEM_ctrl_RR_w   	: std_logic_vector(4 downto 0);
    signal EXE_ctrl_RR_w              		: std_logic_vector(7 downto 0);
  
    signal rs1_sel_RR_w,src1_sel_RR_w,jlr_RR_w,br_RR_w,Sw_RR_w: std_logic;
    signal scr2_sel_RR_w,Rs_en_RR_w 		: std_logic_vector(1 downto 0);        
    signal Rd_or_RS_RR_w	  				: std_logic_vector(2 downto 0);
    signal imm9_Rshifted_RR_w,R7_data_w		: std_logic_vector(15 downto 0);
    
    signal MEM_ctrl_EXE_w   : std_logic_vector(4 downto 0);
    signal scr1_sel_EXE_w,scr2_1_sel_EXE_w,scr2_2_sel_EXE_w,scr2_3_sel_EXE_w    	:  std_logic;
    signal Oper_EXE_w,data_sel_EXE_w,Memaddr_sel_EXE_w,LW_EXE_w          	:  std_logic;
    signal Scr1_wo_forward_w,Scr2_wo_forward_w,Scr1_RR_w,Scr2_RR_w 	:std_logic_vector(15 downto 0);
	signal RS2_w 						:std_logic_vector(2 downto 0);
	signal RegSrc2_w,RegSrc1_w,data_EXEstage_w,data_MEMstage_w,data_WBstage_w,imm6signextd_RR_w :std_logic_vector(15 downto 0);
	signal C_Check_EXE_w,Z_Check_EXE_w,C_Wr_EXE_w,Z_Wr_EXE_w,RegWr_EXE_w: std_logic;
	signal No_CZ_Checked_EXE_w,Checked_carry_EXE_w,Checked_zero_EXE_w,Zero_MEM_WB_w,Wr_en_EXE_w:std_logic;
	signal Carry_sel_w,Zero_sel_w,Carry_EXE_MEM_w,Zero_EXE_MEM_w,RegWr_EXE_MEM_w	: std_logic;
	signal C_Wr_MEM_w,Z_Wr_MEM_w,RegWr_MEM_w,LW_MEM_w,zero_sel_MEM_w,Zero_MEMdata_w : std_logic;


	signal Val_RR_EXE_w					:std_logic;	          
	signal imm6signextd_EXE_w			:std_logic_vector(15 downto 0);	
	signal stall_lm_sm_RR_EXE_w,stall_lm_sm_ExE_w,Val_EXE_w 	:std_logic;
	signal PC_EXE_w				:std_logic_vector(15 downto 0);
	signal RD_EXE_w,Rd_MEM_w			:std_logic_vector(2 downto 0);
	signal Scr1_EXE_w,Scr2_EXE_w 		:std_logic_vector(15 downto 0);	
	signal ALU_in1_EXE_w,ALU_in2_EXE_w,const_to_ALU_signextd_w,SCR2_imm6_to_ALU_w :std_logic_vector(15 downto 0);						
	signal const_to_ALU_w,counter_w		:std_logic_vector(2 downto 0);
	signal Mem_addr_EXE_w	:std_logic_vector(15 downto 0);	
	signal Val_EXE_MEM_w,stall_lm_sm_EXE_MEM_w:std_logic;			
	signal data_in_sel_MEM_w,addr_sel_MEM_w,RD_en_MEM_w,Wr_en_MEM_w,data_sel_MEM_w: std_logic;
	signal ALU_Result_w,PC_MEM_w				:std_logic_vector(15 downto 0);
	signal Zero_EXE_w,Carry_EXE_w,Wr_val_w		:std_logic;
	signal memaddr_smdata_MEM_w,ALUres_imm9exd_MEM_w : std_logic_vector(15 downto 0);		
	signal Carry_MEM_w,Zero_MEM_w,stall_lm_sm_MEM_w,Val_MEM_w 	: std_logic;
	signal WB_ctrl_MEM_w 					:std_logic_vector(4 downto 0);
	signal mem_addr_in_MEM_w,mem_data_in_MEM_w,mem_data_out_MEM_w,PC_WB_w :std_logic_vector(15 downto 0);
	signal Val_MEM_WB_w,wr_en_to_datamem_MEM_w,stall_lm_sm_MEM_WB_w,stall_lm_sm_WB_w,Val_WB_w:std_logic;
	signal C_Check_WB_w,Z_Check_WB_w,C_Wr_WB_w,Z_Wr_WB_w,RegWr_WB_w,Carry_WB_w,Zero_WB_w:std_logic;
	signal carry_wr_en,zero_wr_en,Carry_out,Zero_out :std_logic;
	signal NoFlush_pipe_w,stall_pipe_w	:std_logic_vector(4 downto 0);
	signal Wr_en_regIF_ID_w,Wr_en_regID_RR_w,Wr_en_regRR_EXE_w,Wr_en_regEXE_MEM_w,Wr_en_regMEM_WB_w	:  std_logic;
	signal NoFlush_IF_w,NoFlush_ID_w,NoFlush_RR_w,NoFlush_EXE_w,NoFlush_MEM_w		:  std_logic;

	signal imm_add_val_w,flow_target_val_w,PC_adder_scr1,PC_adder_scr2,nextPC_add_o_w,nextPC_in_w :std_logic_vector(15 downto 0);
	signal br_or_jal_sel_w :std_logic;
	signal nextPC_sel_mux_w,nextR7data_sel_w :std_logic_vector(1 downto 0);

begin
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-------																																			---------
-------													FETCH STAGE																			---------	
-------																																			---------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
	jal_or_br_PC: mux_2x1 generic map (16) port map(PC_ID_w,PC_RR_w,imm_add_val_w,br_or_jal_sel_w);
	imm9_or_inn6_as_add_const:mux_2x1 generic map (16) port map(imm9signextd_ID_w,imm6signextd_RR_w,flow_target_val_w,br_or_jal_sel_w);
	fetch_const_mux: mux_2x1 generic map(16) port map(x"0001",imm_add_val_w,PC_adder_scr1,Br_or_jal_taken_w);
	adder_for_PC: adder port map (PC_adder_scr1,PC_adder_scr2,nextPC_add_o_w);

	fetch_pc_addr_mux: mux_2x1 generic map(16) port map(PC_IF_w,flow_target_val_w,PC_adder_scr2,Br_or_jal_taken_w);
	
	nextPC_sel_mux: mux_4x1 generic map(16) port map (data_WBstage_w,Scr2_RR_w,nextPC_add_o_w,x"0000",nextPC_in_w,nextPC_sel_mux_w);
	tmp_next_PC_reg : register_w generic map(16) port map (nextPC_in_w,clk_w,reset,Tmp_PC_Wr_en_w,PC_IF_w);
	instru_memory :  instru_mem port map (PC_IF_w,IW_IF_w);
	regIFID: regIF_ID generic map(16) port map(IW_IF_w,PC_IF_w,NoFlush_IF_w,clk_w,Wr_en_regIF_ID_w,IW_ID_w,PC_ID_w,Val_ID_w);


---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-------																																			---------
-------													DECODER STAGE																			---------	
-------																																			---------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------

	signext9_16: sign_ext generic map(9,16) port map(IW_ID_w(8 downto 0),imm9signextd_ID_w);
	contrl_dec: control_decoder port map (IW_ID_w(15 downto 12),IW_ID_w(1 downto 0),WB_ctrl_ID_w(4),WB_ctrl_ID_w(3),WB_ctrl_ID_w(2),
										  WB_ctrl_ID_w(1),WB_ctrl_ID_w(0),MEM_ctrl_ID_w(4),MEM_ctrl_ID_w(3),MEM_ctrl_ID_w(2),MEM_ctrl_ID_w(1),
										  MEM_ctrl_ID_w(0),EXE_ctrl_ID_w(7),EXE_ctrl_ID_w(6),EXE_ctrl_ID_w(5),EXE_ctrl_ID_w(4),EXE_ctrl_ID_w(3),
										  EXE_ctrl_ID_w(2),EXE_ctrl_ID_w(1),EXE_ctrl_ID_w(0),RR_ctrl_ID_w(8),RR_ctrl_ID_w(7),RR_ctrl_ID_w(6),
										  RR_ctrl_ID_w(5),RR_ctrl_ID_w(4),RR_ctrl_ID_w(3 downto 2),RR_ctrl_ID_w(1 downto 0),Rd_sel_ID_w ,
										  jal_ID_w ,lm_sm_ID_w );

	lmsm_rd: lm_sm_rd_gen port map(imm_8_in,RD_lmsm_w,imm_8_fb_w,stall_lm_sm_w ,Val_ID_w);
	imm_8_reg8 :register_w  generic map(8) port map(imm_8_fb_w,clk_w,reset,'1',imm_8_rego_w);
	
	rd_sel_mux_4x1: mux_4x1 generic map(3)port map(IW_ID_w(11 downto 9),IW_ID_w(8 downto 6),IW_ID_w(5 downto 3),RD_lmsm_w,Rd_ID_w,Rd_sel_ID_w); 

	imm_8_lmsm_sel_mux_2x1: mux_2x1 generic map (8) port map(IW_ID_w( 7 downto 0),imm_8_rego_w,imm_8_in,stall_lm_sm_RR_w); --here the mux for selecting imm8 or the saved lmsm imm8 need to be updated ,now kept '0'
	
	and2_check_valID: AND_gate port map (NoFlush_ID_w,Val_ID_w,Val_ID_RR_w);
	
	and3_check_lmsmstall: AND_gate3 port map (Val_ID_RR_w,stall_lm_sm_w,lm_sm_ID_w,stall_lm_sm_ID_w);

	regIDRR: regID_RR port map(	PC_ID_w,WB_ctrl_ID_w(4),WB_ctrl_ID_w(3),WB_ctrl_ID_w(2),
								WB_ctrl_ID_w(1),WB_ctrl_ID_w(0),MEM_ctrl_ID_w(4),MEM_ctrl_ID_w(3),MEM_ctrl_ID_w(2),MEM_ctrl_ID_w(1),
								MEM_ctrl_ID_w(0),EXE_ctrl_ID_w(7),EXE_ctrl_ID_w(6),EXE_ctrl_ID_w(5),EXE_ctrl_ID_w(4),EXE_ctrl_ID_w(3),
								EXE_ctrl_ID_w(2),EXE_ctrl_ID_w(1),EXE_ctrl_ID_w(0),RR_ctrl_ID_w(8),RR_ctrl_ID_w(7),RR_ctrl_ID_w(6),
								RR_ctrl_ID_w(5),RR_ctrl_ID_w(4),RR_ctrl_ID_w(3 downto 2),RR_ctrl_ID_w(1 downto 0), IW_ID_w(11 downto 0),
								imm9signextd_ID_w,Rd_ID_w,stall_lm_sm_ID_w,Val_ID_RR_w,clk_w,Wr_en_regID_RR_w,

								PC_RR_w,WB_ctrl_RR_w(4),WB_ctrl_RR_w(3),WB_ctrl_RR_w(2),
								WB_ctrl_RR_w(1),WB_ctrl_RR_w(0),MEM_ctrl_RR_w(4),MEM_ctrl_RR_w(3),MEM_ctrl_RR_w(2),MEM_ctrl_RR_w(1),
								MEM_ctrl_RR_w(0),EXE_ctrl_RR_w(7),EXE_ctrl_RR_w(6),EXE_ctrl_RR_w(5),EXE_ctrl_RR_w(4),EXE_ctrl_RR_w(3),
								EXE_ctrl_RR_w(2),EXE_ctrl_RR_w(1),EXE_ctrl_RR_w(0),rs1_sel_RR_w,src1_sel_RR_w,jlr_RR_w,br_RR_w,Sw_RR_w,
								scr2_sel_RR_w,Rs_en_RR_w,IW_RR_w(11 downto 0),imm9signextd_RR_w,Rd_or_RS_RR_w,stall_lm_sm_RR_w,Val_RR_w);

---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-------																																			---------
-------													REGISTER READ STAGE																		---------	
-------																																			---------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------


	--RR_ctrl_RR_o<=RR_ctrl_RR_w;
	RS2_sel_mux_1:mux_2x1 generic map(3) port map (Rd_or_RS_RR_w,IW_RR_w(8 downto 6),RS2_w,rs1_sel_RR_w); 
	
	register_bank1: register_bank port map (RS2_w,IW_RR_w(11 downto 9),Rd_WB_w,data_WBstage_w,R7_data_w,RegBank_Wr_en_w,Val_WB_w,clk_w,RegSrc1_w,RegSrc2_w);
	
	shift_left_by_7: shiftleft generic map(16) port map (imm9signextd_RR_w,imm9_Rshifted_RR_w);

	Scr1_sel_mux :mux_2x1 generic map (16) port map(RegSrc1_w,RegSrc2_w,Scr1_wo_forward_w,src1_sel_RR_w);
	Scr2_sel_mux :mux_4x1 generic map (16) port map(RegSrc1_w,RegSrc2_w,imm9_Rshifted_RR_w,x"0000",Scr2_wo_forward_w,scr2_sel_RR_w);
	Scr1_w_forward_mux :mux_8x1 generic map(16) port map(Scr1_wo_forward_w,data_EXEstage_w,data_MEMstage_w,data_WBstage_w,PC_RR_w,x"0000",x"0000",x"0000",Scr1_RR_w,fwd_s1); 
	Scr2_w_forward_mux :mux_8x1 generic map(16) port map(Scr2_wo_forward_w,data_EXEstage_w,data_MEMstage_w,data_WBstage_w,PC_RR_w,x"0000",x"0000",x"0000",Scr2_RR_w,fwd_s2);
	signext_imm6:sign_ext generic map (6,16) port map (IW_RR_w(5 downto 0),imm6signextd_RR_w);
	
	and2_check_valRR: AND_gate port map (NoFlush_RR_w,Val_RR_w,Val_RR_EXE_w);
	and2_check_lmsmstallRR: AND_gate port map (stall_lm_sm_RR_w,Val_RR_EXE_w,stall_lm_sm_RR_EXE_w);

	comparator_FOR_branch_check: comparator port map (Scr1_RR_w,Scr2_RR_w,equ_w);

	
	regRREXE :regRR_EXE generic map (16) port map ( WB_ctrl_RR_w(4),WB_ctrl_RR_w(3),WB_ctrl_RR_w(2),WB_ctrl_RR_w(1),WB_ctrl_RR_w(0),MEM_ctrl_RR_w(4),
													MEM_ctrl_RR_w(3),MEM_ctrl_RR_w(2),MEM_ctrl_RR_w(1),MEM_ctrl_RR_w(0),EXE_ctrl_RR_w(7),EXE_ctrl_RR_w(6),
													EXE_ctrl_RR_w(5),EXE_ctrl_RR_w(4),EXE_ctrl_RR_w(3),EXE_ctrl_RR_w(2),EXE_ctrl_RR_w(1),EXE_ctrl_RR_w(0),
													PC_RR_w,Scr1_RR_w,Scr2_RR_w,Rd_or_RS_RR_w,imm6signextd_RR_w,stall_lm_sm_RR_EXE_w,Val_RR_EXE_w,clk_w,
													Wr_en_regRR_EXE_w,		--stall and validity bit needs to be anded with no flush
													
													--WB_ctrl_EXE_w(4),WB_ctrl_EXE_w(3),WB_ctrl_EXE_w(2),WB_ctrl_EXE_w(1),WB_ctrl_EXE_w(0),
													C_Check_EXE_w,Z_Check_EXE_w,C_Wr_EXE_w,Z_Wr_EXE_w,RegWr_EXE_w,
													MEM_ctrl_EXE_w(4),MEM_ctrl_EXE_w(3),MEM_ctrl_EXE_w(2),MEM_ctrl_EXE_w(1),MEM_ctrl_EXE_w(0),
													scr1_sel_EXE_w,scr2_1_sel_EXE_w,scr2_2_sel_EXE_w,scr2_3_sel_EXE_w,Oper_EXE_w,data_sel_EXE_w,Memaddr_sel_EXE_w,LW_EXE_w,
													PC_EXE_w,Scr1_EXE_w,Scr2_EXE_w,RD_EXE_w,imm6signextd_EXE_w,stall_lm_sm_ExE_w,Val_EXE_w);
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-------																																			---------
-------														EXECUTION STAGE																		---------	
-------																																			---------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------


	counter_3:counter port map(clk_w,stall_lm_sm_EXE_w,counter_w);
	SCR1_or_PC_selmux: mux_2x1 generic map(16) port map (Scr1_EXE_w,PC_EXE_w,ALU_in1_EXE_w,scr1_sel_EXE_w);
	SCR2_or_imm6extd_selmu :mux_2x1 generic map (16) port map (	Scr2_EXE_w,imm6signextd_EXE_w,SCR2_imm6_to_ALU_w,scr2_1_sel_EXE_w);
	counter_or_1_selmux: mux_2x1 generic map(3) port map ("001",counter_w,const_to_ALU_w,scr2_2_sel_EXE_w);
	constant_signext :sign_ext generic map (3,16) port map(const_to_ALU_w,const_to_ALU_signextd_w);
	const_or_value_selmux : mux_2x1 generic map(16) port map (SCR2_imm6_to_ALU_w,const_to_ALU_signextd_w,ALU_in2_EXE_w,scr2_3_sel_EXE_w);
	main_alu :alu generic map(16) port map (ALU_in1_EXE_w,ALU_in2_EXE_w,Oper_EXE_w,ALU_Result_w,Zero_EXE_w,Carry_EXE_w);
	data_EXE_sel: mux_2x1 generic map(16) port map (Scr2_EXE_w,ALU_Result_w,data_EXEstage_w,data_sel_EXE_w); ---the data_EXE include ALU result or the imm9 sign extd
	mem_addr_EXEstage_sel : mux_2x1 generic map(16) port map (Scr1_EXE_w,Scr2_EXE_w,Mem_addr_EXE_w,Memaddr_sel_EXE_w); 		-- the Mem_addr_EXE_w will include the mem addr or the sm_data also
	
	dont_check_C_Z_and: NOR_gate port map (C_Check_EXE_w,Z_Check_EXE_w,No_CZ_Checked_EXE_w);
	Checking_carry	:AND_gate port map (C_Check_EXE_w,Carry_MEM_w,Checked_carry_EXE_w);
	Checking_Zero 	:AND_gate port map (Z_Check_EXE_w,Zero_MEM_WB_w,Checked_zero_EXE_w);
	Wr_enabling_or	:OR_gate3 port map (No_CZ_Checked_EXE_w,Checked_carry_EXE_w,Checked_zero_EXE_w,Wr_en_EXE_w);
	
	and3_check_Wr_back_valEXE: AND_gate3 port map (NoFlush_EXE_w,Val_EXE_w,Wr_en_EXE_w,Wr_val_w);
	and2_check_lmsmstallEXE: AND_gate port map (stall_lm_sm_ExE_w,Wr_val_w,stall_lm_sm_EXE_MEM_w);
	and2_instr_valEXE: AND_gate port map (NoFlush_EXE_w,Val_EXE_w,Val_EXE_MEM_w);

	Carry_Wr_EXE_val : AND_gate port map (Wr_val_w,C_Wr_EXE_w,Carry_sel_w);
	Zero_Wr_EXE_val : AND_gate port map (Wr_val_w,Z_Wr_EXE_w,Zero_sel_w);
	RegWr_EXE_val :	AND_gate port map (Wr_val_w,RegWr_EXE_w,RegWr_EXE_MEM_w);

	carry_mux: mux_2x1_1bit port map (Carry_MEM_w,Carry_EXE_w,Carry_EXE_MEM_w,Carry_sel_w);
	zero_mux: mux_2x1_1bit  port map (Zero_MEM_WB_w,Zero_EXE_w,Zero_EXE_MEM_w,Zero_sel_w);



	
	regEXEMEM : regEXE_MEM generic map(16) port map (PC_EXE_w,Carry_sel_w,Zero_sel_w,RegWr_EXE_MEM_w,LW_EXE_w,
													 MEM_ctrl_EXE_w(4),MEM_ctrl_EXE_w(3),MEM_ctrl_EXE_w(2),MEM_ctrl_EXE_w(1),MEM_ctrl_EXE_w(0),
													 Mem_addr_EXE_w,data_EXEstage_w,Carry_EXE_MEM_w,Zero_EXE_MEM_w,RD_EXE_w, stall_lm_sm_EXE_MEM_w,Val_EXE_MEM_w,clk_w,
													 Wr_en_regEXE_MEM_w,PC_MEM_w,
	
													 C_Wr_MEM_w,Z_Wr_MEM_w,RegWr_MEM_w,LW_MEM_w,
													 data_in_sel_MEM_w,addr_sel_MEM_w,RD_en_MEM_w,Wr_en_MEM_w,data_sel_MEM_w,
													 memaddr_smdata_MEM_w,ALUres_imm9exd_MEM_w,Carry_MEM_w,Zero_MEM_w,Rd_MEM_w,stall_lm_sm_MEM_w,Val_MEM_w);
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-------																																			---------
-------													MEMORY  STAGE																			---------	
-------																																			---------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------


	mem_addr_sel_mux: mux_2x1 generic map(16) port map (memaddr_smdata_MEM_w,ALUres_imm9exd_MEM_w,mem_addr_in_MEM_w,addr_sel_MEM_w);
	mem_data_sel_mux: mux_2x1 generic map(16) port map (ALUres_imm9exd_MEM_w,memaddr_smdata_MEM_w,mem_data_in_MEM_w,data_in_sel_MEM_w);
	mem_wr_en : AND_gate port map (Wr_en_MEM_w,Val_MEM_WB_w,wr_en_to_datamem_MEM_w);
	and2_check_valMEM		: AND_gate port map (NoFlush_MEM_w,Val_MEM_w,Val_MEM_WB_w);
	and2_check_lmsmstallMEM	: AND_gate port map (stall_lm_sm_MEM_w,Val_MEM_WB_w,stall_lm_sm_MEM_WB_w);
	data_memory : data_mem port map (mem_addr_in_MEM_w,mem_data_in_MEM_w,mem_data_out_MEM_w,RD_en_MEM_w,wr_en_to_datamem_MEM_w,clk_w);
	data_MEM_sel: mux_2x1 generic map(16) port map (mem_data_out_MEM_w,ALUres_imm9exd_MEM_w,data_MEMstage_w,data_sel_MEM_w);
	zero_dec_mem_data: zero_detector port map (mem_data_out_MEM_w,Zero_MEMdata_w);

	zero_flag_sel : AND_gate port map (LW_MEM_w,Val_MEM_WB_w,zero_sel_MEM_w);
	Zero_flag_after_LW: mux_2x1_1bit port map (Zero_MEM_w,Zero_MEMdata_w,Zero_MEM_WB_w,zero_sel_MEM_w);


	regMEMWB : regMEM_WB generic map (16) port map(PC_MEM_w,C_Wr_MEM_w,Z_Wr_MEM_w,RegWr_MEM_w,
													data_MEMstage_w,Carry_MEM_w,Zero_MEM_WB_w,Rd_MEM_w,stall_lm_sm_MEM_WB_w,Val_MEM_WB_w,clk_w,Wr_en_regMEM_WB_w,PC_WB_w,
													C_Wr_WB_w,Z_Wr_WB_w,RegWr_WB_w,data_WBstage_w,Carry_WB_w,Zero_WB_w,Rd_WB_w,stall_lm_sm_WB_w,Val_WB_w);
	
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-------																																			---------
-------													WRITE BACK STAGE																		---------	
-------																																			---------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
	
	next_R7data_sel:nextR7data port map (Val_MEM_WB_w,Val_EXE_MEM_w,Val_RR_EXE_w,nextR7data_sel_w);

	r7data_mux : mux_4x1 generic map(16) port map (PC_MEM_w,PC_EXE_w,PC_RR_w,x"0000",R7_data_w,nextR7data_sel_w);

	carry_write_back_enable: AND_gate port map (C_Wr_WB_w,Val_WB_w,carry_wr_en);
	zero_write_back_enable: AND_gate port map (Z_Wr_WB_w,Val_WB_w,zero_wr_en);

	register_wr_back_enable: AND_gate port map (RegWr_WB_w,Val_WB_w,RegBank_Wr_en_w);
	
	
	carry_register: register_1 port map (Carry_WB_w,clk_w,carry_wr_en,Carry_out);
	zero_register: register_1 port map (Zero_WB_w,clk_w,zero_wr_en,Zero_out);
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-------																																			---------
-------													HAZARD DETECTION UNIT AND FORWARING UNIT													---------	
-------																																			---------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
	

	hazard:hdu port map (RegBank_Wr_en_w,LW_EXE_w,br_RR_w,equ_w,jlr_RR_w,jal_ID_w,stall_lm_sm_ID_w,Val_EXE_MEM_w,Val_RR_EXE_w,Rd_WB_w,Rs_en_RR_w,RS2_w,IW_RR_w(11 downto 9),
						 RD_EXE_w,NoFlush_pipe_w,stall_pipe_w,R7_Wr_en_w,Br_or_jal_taken_w,br_or_jal_sel_w,Tmp_PC_Wr_en_w,nextPC_sel_mux_w);

	NoFlush_IF_w <= NoFlush_pipe_w(4);
	NoFlush_ID_w <= NoFlush_pipe_w(3);
	NoFlush_RR_w <= NoFlush_pipe_w(2);
	NoFlush_EXE_w <= NoFlush_pipe_w(1);
	NoFlush_MEM_w <= NoFlush_pipe_w(0);

	Wr_en_regIF_ID_w <= stall_pipe_w(4);
	Wr_en_regID_RR_w <= stall_pipe_w(3);
	Wr_en_regRR_EXE_w <= stall_pipe_w(2);
	Wr_en_regEXE_MEM_w <= stall_pipe_w(1);
	Wr_en_regMEM_WB_w <= stall_pipe_w(0);

	WB_ctrl_MEM_o<=WB_ctrl_MEM_w;
	--MEM_ctrl_MEM_o<=MEM_ctrl_MEM_w;

end behav;