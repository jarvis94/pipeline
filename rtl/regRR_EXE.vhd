library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 1 - IF stage to ID stage

Entity regRR_EXE is
    Generic(W : integer:=16);
    Port (
          WB_C_Check,WB_Z_Check,WB_C_Wr,WB_Z_Wr,WB_RegWr          : in std_logic;
          MEM_data_in_sel,MEM_addr_sel,MEM_RD_en,MEM_Wr_en,MEM_dat: in std_logic;
          EXE_scr1,EXE_scr2_1,EXE_scr2_2,EXE_scr2_3               : in std_logic;
          EXE_Oper,EXE_data,EXE_Memaddr,EXE_LW                    : in std_logic;
          pc            : in std_logic_vector(W-1 downto 0);
          Scr1,Scr2,Rd  : in std_logic_vector(2 downto 0);
          imm6_sign_extd: in std_logic_vector(15 downto 0);
          stall_lm_sm   : in std_logic;
          val           : in std_logic;
          clk,wr_en     : in std_logic;
          WB_C_Check_o,WB_Z_Check_o,WB_C_Wr_o ,WB_Z_Wr_o,WB_RegWr_o         : out std_logic;
          MEM_data_in_sel_o,MEM_addr_sel_o,MEM_RD_en_o,MEM_Wr_en_o,MEM_dat_o: out std_logic;
          EXE_scr1_o,EXE_scr2_1_o,EXE_scr2_2_o,EXE_scr2_3_o                 : out std_logic;
          EXE_Oper_o,EXE_data_o,EXE_Memaddr_o,EXE_LW_o                      : out std_logic;
          pc_out            : out std_logic_vector(W-1 downto 0);
          Scr1_o,Scr2_o,Rd_o: out std_logic_vector(2 downto 0);
          imm6_sign_extd_o  : out std_logic_vector(15 downto 0);
          stall_lm_sm_o : out std_logic;
          val_out       : out std_logic);
    End regRR_EXE;

Architecture behav of regRR_EXE is
    begin
        process(clk)
        begin
            if( clk'event and clk = '1' and wr_en ='1') then
                WB_C_Check_o      <= WB_C_Check;
                WB_Z_Check_o      <= WB_Z_Check;
                WB_C_Wr_o         <= WB_C_Wr;   
                WB_Z_Wr_o         <= WB_Z_Wr;
                WB_RegWr_o        <= WB_RegWr;
                MEM_data_in_sel_o <= MEM_data_in_sel;
                MEM_addr_sel_o    <= MEM_addr_sel;
                MEM_RD_en_o       <= MEM_RD_en;
                MEM_Wr_en_o       <= MEM_Wr_en;
                MEM_dat_o         <= MEM_dat;
                EXE_scr1_o        <= EXE_scr1;
                EXE_scr2_1_o      <= EXE_scr2_1;
                EXE_scr2_2_o      <= EXE_scr2_2;
                EXE_scr2_3_o      <= EXE_scr2_3;
                EXE_Oper_o        <= EXE_Oper;
                EXE_data_o        <= EXE_data;
                EXE_Memaddr_o     <= EXE_Memaddr;
                EXE_LW_o          <= EXE_LW;
                pc_out            <= pc;
                Scr1_o            <= Scr1;
                Scr2_o            <= Scr2;
                Rd_o              <= Rd;
                imm6_sign_extd_o  <= imm6_sign_extd;
                stall_lm_sm_o     <= stall_lm_sm;
                val_out           <= val;
            end if;
        end process;
    end;
