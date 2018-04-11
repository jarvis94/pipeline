library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 1 - IF stage to ID stage

Entity regMEM_WB is
    Generic(W : integer:=16);
    Port (
          pc            : in std_logic_vector(W-1 downto 0);
          WB_C_Check,WB_Z_Check,WB_C_Wr,WB_Z_Wr,WB_RegWr : in std_logic;
          WBdata        : in std_logic_vector(W-1 downto 0);
          Carry,Zero    : in std_logic;
          Rd            : in std_logic_vector(2 downto 0);
          stall_lm_sm   : in std_logic;
          val           : in std_logic;
          clk,wr_en     : in std_logic;
          pc_out          : out std_logic_vector(W-1 downto 0);
          WB_C_Check_o,WB_Z_Check_o,WB_C_Wr_o ,WB_Z_Wr_o,WB_RegWr_o : out std_logic;
          WBdata_o        : out std_logic_vector(W-1 downto 0);
          Carry_o,Zero_o  : out std_logic;
          Rd_o            : out std_logic_vector(2 downto 0);
          stall_lm_sm_o   : out std_logic;
          val_out         : out std_logic);
    End regMEM_WB;

Architecture behav of regMEM_WB is
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
                WBdata_o          <= WBdata;
                Carry_o           <= Carry;
                Zero_o            <= Zero;
                Rd_o              <= Rd;
                stall_lm_sm_o     <= stall_lm_sm;
                val_out           <= val;
            end if;
        end process;
    end;
