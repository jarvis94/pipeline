library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 1 - IF stage to ID stage

Entity regEXE_MEM is
    Generic(W : integer:=16);
    Port (
          pc            : in std_logic_vector(W-1 downto 0);
          WB_C_Check,WB_Z_Check,WB_C_Wr,WB_Z_Wr,WB_RegWr          : in std_logic;
          MEM_data_in_sel,MEM_addr_sel,MEM_RD_en,MEM_Wr_en,MEM_dat: in std_logic;
          memaddr_smdata: in std_logic_vector(W-1 downto 0);
          ALUres_imm9exd: in std_logic_vector(W-1 downto 0);
          Carry,Zero    : in std_logic;
          Rd            : in std_logic_vector(2 downto 0);
          stall_lm_sm   : in std_logic;
          val           : in std_logic;
          clk,wr_en     : in std_logic;
          pc_out          : out std_logic_vector(W-1 downto 0);
          WB_C_Check_o,WB_Z_Check_o,WB_C_Wr_o ,WB_Z_Wr_o,WB_RegWr_o         : out std_logic;
          MEM_data_in_sel_o,MEM_addr_sel_o,MEM_RD_en_o,MEM_Wr_en_o,MEM_dat_o: out std_logic;
          memaddr_smdata_o: out std_logic_vector(W-1 downto 0);
          ALUres_imm9exd_o: out std_logic_vector(W-1 downto 0);
          Carry_o,Zero_o  : out std_logic;
          Rd_o            : out std_logic_vector(2 downto 0);
          stall_lm_sm_o   : out std_logic;
          val_out         : out std_logic);
    End regEXE_MEM;

Architecture behav of regEXE_MEM is
    begin
        process(clk)
        begin
            if( clk'event and clk = '1' and wr_en ='1') then
                pc_out            <= pc;
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
                memaddr_smdata_o  <= memaddr_smdata;
                ALUres_imm9exd_o  <= ALUres_imm9exd;
                Carry_o           <= Carry;
                Zero_o            <= Zero;
                Rd_o              <= Rd;
                stall_lm_sm_o     <= stall_lm_sm;
                val_out           <= val;
            end if;
        end process;
    end;
