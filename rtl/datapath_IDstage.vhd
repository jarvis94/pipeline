--DATAPATH FOR DECODER
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity datapath_IDstage is
	port (
			PC_IF_w	 			:in std_logic_vector(15 downto 0);
			IW_IF_w				: in std_logic_vector(15 downto 0);
			clk_w				:in std_logic;
			Wr_en_regIF_ID_w	: in std_logic;
			NoFlush_IF_w		: in std_logic;
			Wr_en_regID_RR_w	: in std_logic;
			NoFlush_ID_w		: in std_logic;
			RD_mux_sel			: in std_logic_vector(1 downto 0);
			WB_ctrl_RR_o,MEM_ctrl_RR_o  : out std_logic_vector(4 downto 0);
     		EXE_ctrl_RR_o              	: out  std_logic_vector(7 downto 0);
    		RR_ctrl_RR_o               	: out std_logic_vector(8 downto 0)
    		--mux_imm8_or_fb				: in std_logic
    		 );
end datapath_IDstage;

architecture behav of datapath_IDstage is

	component sign_ext
		generic(In_W: integer:=9;
				OUT_W: integer:=16);
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

	component mux_2x1
	port (
		mux_in1,mux_in2 : in std_logic_vector(7 downto 0);
		mux_out: out std_logic_vector(7 downto 0);
		mux_sel: in std_logic
		);
	end component;
	for imm_8_lmsm_sel_mux_2x1: mux_2x1 use entity work.mux_2x1(behav);

	component register_w 
	generic(W: integer:=16);
	port (
	    Wr_data     :in std_logic_vector(W-1 downto 0);
	    clk,reset   :in std_logic;
	    Reg_data    :out std_logic_vector(W-1 downto 0));
	end component;
	for imm_8_reg8: register_w use entity work.register_w(behav);         

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
	for and2_check_val: AND_gate use entity work.AND_gate(behav);


	component AND_gate3
		port ( 	A, B ,C 	:in std_logic;
		  	ANDout	:out std_logic);
	end component;
	for and3_check_lmsmstall: AND_gate3 use entity work.AND_gate3(behav);



	signal IW_ID_w, PC_ID_w,imm9signextd_ID_w	:std_logic_vector(15 downto 0);
	signal imm_8_in,imm_8_fb_w,imm_8_rego_w	    : std_logic_vector(7 downto 0);
	signal Val_ID_w,stall_lm_sm_ID_w,stall_lm_sm_w ,stall_lm_sm_RR_w		: std_logic; 
	signal WB_ctrl_ID_w,MEM_ctrl_ID_w   : std_logic_vector(4 downto 0);
    signal EXE_ctrl_ID_w              	: std_logic_vector(7 downto 0);
    signal RR_ctrl_ID_w               	: std_logic_vector(8 downto 0);
    signal Rd_sel_ID_w                  : std_logic_vector(1 downto 0);
    signal jal_ID_w ,lm_sm_ID_w         : std_logic;
    signal RD_lmsm_w,Rd_ID_w	  		: std_logic_vector(2 downto 0);
    signal Val_ID_IF_w					:std_logic;	
    signal PC_RR_w,imm9signextd_RR_w	:std_logic_vector(15 downto 0);
    signal IW_RR_w						:std_logic_vector(11 downto 0);

	signal Val_RR_w 					: std_logic; 
	signal WB_ctrl_RR_w,MEM_ctrl_RR_w   : std_logic_vector(4 downto 0);
    signal EXE_ctrl_RR_w              	: std_logic_vector(7 downto 0);
  
    signal rs1_sel_RR_w,src1_sel_RR_w,jlr_RR_w,br_RR_w,Sw_RR_w: std_logic;
    signal scr2_sel_RR_w,Rs_en_RR_w 		: std_logic_vector(1 downto 0);        

--    signal RR_ctrl_Rr_w               	: std_logic_vector(8 downto 0);
    signal Rd_RR_w	  					: std_logic_vector(2 downto 0);
       
begin


	regIFID: regIF_ID generic map(16) port map(IW_IF_w,PC_IF_w,NoFlush_IF_w,clk_w,Wr_en_regIF_ID_w,IW_ID_w,PC_ID_w,Val_ID_w);
	signext9_16: sign_ext generic map(9,16) port map(IW_ID_w(8 downto 0),imm9signextd_ID_w);
	contrl_dec: control_decoder port map (IW_ID_w(15 downto 12),IW_ID_w(1 downto 0),WB_ctrl_ID_w(4),WB_ctrl_ID_w(3),WB_ctrl_ID_w(2),
										  WB_ctrl_ID_w(1),WB_ctrl_ID_w(0),MEM_ctrl_ID_w(4),MEM_ctrl_ID_w(3),MEM_ctrl_ID_w(2),MEM_ctrl_ID_w(1),
										  MEM_ctrl_ID_w(0),EXE_ctrl_ID_w(7),EXE_ctrl_ID_w(6),EXE_ctrl_ID_w(5),EXE_ctrl_ID_w(4),EXE_ctrl_ID_w(3),
										  EXE_ctrl_ID_w(2),EXE_ctrl_ID_w(1),EXE_ctrl_ID_w(0),RR_ctrl_ID_w(8),RR_ctrl_ID_w(7),RR_ctrl_ID_w(6),
										  RR_ctrl_ID_w(5),RR_ctrl_ID_w(4),RR_ctrl_ID_w(3 downto 2),RR_ctrl_ID_w(1 downto 0),Rd_sel_ID_w ,
										  jal_ID_w ,lm_sm_ID_w );

	lmsm_rd: lm_sm_rd_gen port map(imm_8_in,RD_lmsm_w,imm_8_fb_w,stall_lm_sm_w ,Val_ID_w);
	imm_8_reg8 :register_w  generic map(8) port map(imm_8_fb_w,clk_w,'0',imm_8_rego_w);
	
	rd_sel_mux_4x1: mux_4x1 generic map(3)port map(IW_ID_w(11 downto 9),IW_ID_w(8 downto 6),IW_ID_w(5 downto 3),RD_lmsm_w,Rd_ID_w,RD_mux_sel); 

	imm_8_lmsm_sel_mux_2x1: mux_2x1 port map(IW_ID_w( 7 downto 0),imm_8_rego_w,imm_8_in,stall_lm_sm_RR_w); --here the mux for selecting imm8 or the saved lmsm imm8 need to be updated ,now kept '0'
	
	and2_check_val: AND_gate port map (NoFlush_IF_w,Val_ID_w,Val_ID_IF_w);
	
	and3_check_lmsmstall: AND_gate3 port map (Val_ID_IF_w,stall_lm_sm_w,lm_sm_ID_w,stall_lm_sm_ID_w);

	regIDRR: regID_RR port map(	PC_ID_w,WB_ctrl_ID_w(4),WB_ctrl_ID_w(3),WB_ctrl_ID_w(2),
								WB_ctrl_ID_w(1),WB_ctrl_ID_w(0),MEM_ctrl_ID_w(4),MEM_ctrl_ID_w(3),MEM_ctrl_ID_w(2),MEM_ctrl_ID_w(1),
								MEM_ctrl_ID_w(0),EXE_ctrl_ID_w(7),EXE_ctrl_ID_w(6),EXE_ctrl_ID_w(5),EXE_ctrl_ID_w(4),EXE_ctrl_ID_w(3),
								EXE_ctrl_ID_w(2),EXE_ctrl_ID_w(1),EXE_ctrl_ID_w(0),RR_ctrl_ID_w(8),RR_ctrl_ID_w(7),RR_ctrl_ID_w(6),
								RR_ctrl_ID_w(5),RR_ctrl_ID_w(4),RR_ctrl_ID_w(3 downto 2),RR_ctrl_ID_w(1 downto 0), IW_ID_w(11 downto 0),
								imm9signextd_ID_w,Rd_ID_w,stall_lm_sm_ID_w,Val_ID_IF_w,clk_w,Wr_en_regID_RR_w,

								PC_RR_w,WB_ctrl_RR_w(4),WB_ctrl_RR_w(3),WB_ctrl_RR_w(2),
								WB_ctrl_RR_w(1),WB_ctrl_RR_w(0),MEM_ctrl_RR_w(4),MEM_ctrl_RR_w(3),MEM_ctrl_RR_w(2),MEM_ctrl_RR_w(1),
								MEM_ctrl_RR_w(0),EXE_ctrl_RR_w(7),EXE_ctrl_RR_w(6),EXE_ctrl_RR_w(5),EXE_ctrl_RR_w(4),EXE_ctrl_RR_w(3),
								EXE_ctrl_RR_w(2),EXE_ctrl_RR_w(1),EXE_ctrl_RR_w(0),rs1_sel_RR_w,src1_sel_RR_w,jlr_RR_w,br_RR_w,Sw_RR_w,
								scr2_sel_RR_w,Rs_en_RR_w,IW_RR_w(11 downto 0),imm9signextd_RR_w,Rd_RR_w,stall_lm_sm_RR_w,Val_RR_w);
	WB_ctrl_RR_o<=WB_ctrl_RR_w;
	MEM_ctrl_RR_o<=MEM_ctrl_RR_w;
	EXE_ctrl_RR_o<=EXE_ctrl_RR_w;
	--RR_ctrl_RR_o<=RR_ctrl_RR_w;


end behav;