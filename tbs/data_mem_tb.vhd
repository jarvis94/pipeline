library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;  --include package textio.vhd

entity data_mem_tb is
end data_mem_tb ;

architecture arc of data_mem_tb  is

signal  addr,wr_data,mem_data :std_logic_vector(15 downto 0);
signal  Rd_en,Wr_en,clk : std_logic;
signal initialised :std_logic :='0';

begin
    dut_and_2: entity work.data_mem(behav)  port map(addr,wr_data,mem_data,Rd_en,Wr_en,clk);

Cl :process -- create free-running test clock
    begin
        clk <= '0'; wait for 5 ns;       -- clock cycle 10 ns
        clk <= '1'; wait for 5 ns;
    end process;

initialise_mem:process(clk)
    file   infile    : text is in  "1.txt";   --declare input file
    variable  inline    : line; --line number declaration
    variable  dataread1    : bit_vector(0 to 15);
    variable count      : integer:=0;
    begin
        if(clk'event and clk='1') then
            if (not endfile(infile)) then
                readline(infile,inline);
                read(inline,dataread1);
                addr<= std_logic_vector(to_unsigned(count,16));
                wr_data<=to_stdlogicvector(dataread1) after 10 ps;
                Wr_en<='1';
                count:=count+1;
                
            else
                initialised<='1';
                count:=count-1;
                addr<= std_logic_vector(to_unsigned(count,16));
                Wr_en<='0';
                Rd_en<='1' after 1 ns;
            end if;
        end if;
end process initialise_mem;
end arc;



--stimulus:process

 --   
--    begin
--    
--        RS1<="001";
--        RS2<="011";
--        RD<="101";
--        WB_data<=x"1010";
--        R7_data<=x"1100";
--        Reg_Wr_en<='0';
--        R7_Wr_en<='1';
--
 --       wait for 15 ns;
--        
--        RS1<="001";
--        RS2<="011";
--        RD<="101";
--        WB_data<=x"1010";
--        R7_data<=x"1100";
--        Reg_Wr_en<='1';
--        R7_Wr_en<='1';
--
 --       wait for 10 ns;
--        
--        RS1<="001";
--        RS2<="011";
--        RD<="011";
--        WB_data<=x"1111";
--        R7_data<=x"10AB";
--        Reg_Wr_en<='1';
--        R7_Wr_en<='1';
--
 --       wait for 12 ns;
--        RS1<="001";
--        RS2<="111";
--        RD<="111";
--        WB_data<=x"FF11";
--        R7_data<=x"10AB";
--        Reg_Wr_en<='1';
--        R7_Wr_en<='1';
--        
--        wait for 15 ns;
--
 --       wait;
--    end process;
--end arc;