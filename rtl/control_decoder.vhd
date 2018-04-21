library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 1 - IF stage to ID stage

Entity control_decoder is
    
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
    End control_decoder;

Architecture behav of control_decoder is
    begin
        process(opcode,CZ)
        begin
            if( opcode = b"00_00" and CZ = "00") then  --ADD
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '1';   
                WB_Z_Wr         <= '1';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '0';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '1';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "10";
            elsif( opcode = b"00_00" and CZ = "10") then  --ADC
                WB_C_Check      <= '1';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '1';   
                WB_Z_Wr         <= '1';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '0';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '1';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "10";
            elsif( opcode = b"00_00" and CZ = "01") then  --ADZ
                WB_C_Check      <= '0';
                WB_Z_Check      <= '1';
                WB_C_Wr         <= '1';   
                WB_Z_Wr         <= '1';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '0';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '1';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "10"; --checked

            elsif( opcode = b"00_01") then  --ADI
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '1';   
                WB_Z_Wr         <= '1';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '1';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '-';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "--";
                RR_Rs_en        <= "01";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "01";   

            elsif( opcode = b"00_10" and CZ = "00") then  --NDU
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '1';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '0';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '0';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '1';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "10";    
             elsif( opcode = b"00_10" and CZ = "10") then  --NDC
                WB_C_Check      <= '1';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '1';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '0';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '0';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '1';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "10";    
            elsif( opcode = b"00_10" and CZ = "01") then  --NDZ
                WB_C_Check      <= '0';
                WB_Z_Check      <= '1';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '1';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '0';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '0';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '1';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "10";    
            elsif( opcode = b"00_11") then  --LHI
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '0';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '-';
                EXE_scr2_1      <= '-';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '-';
                EXE_Oper        <= '-';
                EXE_data        <= '0';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '-';
                RR_src1_sel     <= '-';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "10";
                RR_Rs_en        <= "00";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "00";    --checked
            
             elsif( opcode = b"01_00" ) then  --LW
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '1';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '1';
                MEM_RD_en       <= '1';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '0';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '1';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '1';
                RR_rs1_sel      <= '0';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "--";
                RR_Rs_en        <= "10";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "01";    --not sure, think its checked

            elsif( opcode = b"01_01" ) then  --SW
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '0';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '1';
                MEM_addr_sel    <= '1';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '1';
                MEM_dat         <= '-';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '1';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '1';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '0';
                RR_src1_sel     <= '0';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '1';
                RR_scr2_sel     <= "01";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "--";

            elsif( opcode = b"01_10" ) then  --LM
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '0';
                WB_RegWr        <= '1';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '1';
                MEM_RD_en       <= '1';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '0';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '-';
                EXE_scr2_2      <= '1';
                EXE_scr2_3      <= '1';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '-';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "--";
                RR_Rs_en        <= "01";
                ID_jal          <= '0';
                ID_lm_sm        <= '1';
                ID_Rd_sel       <= "11";

            elsif( opcode = b"01_11" ) then  --SM
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '0';
                WB_RegWr        <= '0';
                MEM_data_in_sel <= '1';
                MEM_addr_sel    <= '1';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '1';
                MEM_dat         <= '-';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '-';
                EXE_scr2_2      <= '1';
                EXE_scr2_3      <= '1';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '1';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '0';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';
                ID_lm_sm        <= '1';
                ID_Rd_sel       <= "11";


            elsif( opcode = b"11_00" ) then  --BEQ
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '0';
                WB_RegWr        <= '0';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '-';
                EXE_scr1        <= '-';
                EXE_scr2_1      <= '-';
                EXE_scr2_2      <= '-';
                EXE_scr2_3      <= '-';
                EXE_Oper        <= '-';
                EXE_data        <= '-';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '1';
                RR_src1_sel     <= '1';
                RR_jlr          <= '0';
                RR_br           <= '1';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "01";
                RR_Rs_en        <= "11";
                ID_jal          <= '0';                
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "--";


            elsif( opcode = b"10_00" ) then  --JAL
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '0';
                WB_RegWr        <= '0';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '1';
                EXE_scr2_1      <= '-';
                EXE_scr2_2      <= '0';
                EXE_scr2_3      <= '1';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '-';
                RR_src1_sel     <= '-';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "--";
                RR_Rs_en        <= "00";
                ID_jal          <= '1';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "--";


            elsif( opcode = b"10_01" ) then  --JLR
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '0';
                WB_RegWr        <= '0';
                MEM_data_in_sel <= '-';
                MEM_addr_sel    <= '-';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '1';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '-';
                EXE_scr2_2      <= '0';
                EXE_scr2_3      <= '1';
                EXE_Oper        <= '1';
                EXE_data        <= '1';
                EXE_Memaddr     <= '-';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '1';
                RR_src1_sel     <= '-';
                RR_jlr          <= '1';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "10";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "--";
            else
                WB_C_Check      <= '0';
                WB_Z_Check      <= '0';
                WB_C_Wr         <= '0';   
                WB_Z_Wr         <= '0';
                WB_RegWr        <= '0';
                MEM_data_in_sel <= '0';
                MEM_addr_sel    <= '0';
                MEM_RD_en       <= '0';
                MEM_Wr_en       <= '0';
                MEM_dat         <= '0';
                EXE_scr1        <= '0';
                EXE_scr2_1      <= '0';
                EXE_scr2_2      <= '0';
                EXE_scr2_3      <= '0';
                EXE_Oper        <= '0';
                EXE_data        <= '0';
                EXE_Memaddr     <= '0';
                EXE_LW          <= '0';
                RR_rs1_sel      <= '0';
                RR_src1_sel     <= '0';
                RR_jlr          <= '0';
                RR_br           <= '0';
                RR_Sw           <= '0';
                RR_scr2_sel     <= "00";
                RR_Rs_en        <= "00";
                ID_jal          <= '0';
                ID_lm_sm        <= '0';
                ID_Rd_sel       <= "00";    

              end if;

        end process;
    end;
