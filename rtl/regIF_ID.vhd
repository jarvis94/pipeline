library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 1 - IF stage to ID stage

Entity regIF_ID is
    Generic(W : integer);
    Port (instruction : in std_logic_vector(W-1 downto 0);
          pc          : in std_logic_vector(W-1 downto 0);
          val         : in std_logic;
          clk,wr_en   : in std_logic;
          instr_out   : out std_logic_vector(W-1 downto 0);
          pc_out      : out std_logic_vector(W-1 downto 0);
          val_out: out std_logic);
    End regIF_ID;

Architecture behav of regIF_ID is
    begin
        process(clk)
        begin
            if( clk'event and clk = '1' and wr_en ='1') then
                instr_out <= instruction;
                pc_out <= pc;
                val_out<=val;
            end if;
        end process;
    end;
