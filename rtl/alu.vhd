library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

Entity alu is
Generic(W : natural := 16);
    port(SrcA           : in std_logic_vector(W-1 downto 0);
         SrcB           : in std_logic_vector(W-1 downto 0);
         AluOperation   : in std_logic;
         AluResult      : out std_logic_vector(W-1 downto 0);
         Zero           : out std_logic;
         CarryOut       : out std_logic);
End alu;


Architecture RTL of alu is

begin
        process (SrcA,SrcB,AluOperation)

        Variable Y : std_logic_vector(W downto 0);
        Variable Aux : std_logic;
        Variable my_zero : std_logic_vector(W-1 downto 0);
        begin
            Y := "00000000000000000"; --for W value other than 16, will have to edit here
            --Y := std_logic_vector(to_unsigned(0, W));
            if AluOperation ='0'then

                Y := '0' & (SrcA AND SrcB);

            else  
            
                Y := std_logic_vector(unsigned('0' & SrcA) + unsigned('0' & SrcB));
            
            end if;

            -- Check if Zero
            if Y = "00000000000000000" then   --for W value other than 16, will have to edit here
                Zero <= '1';
            else
                Zero <= '0';
            end if;

            -- Check if CarryOut is there
            if Y(16) = '1' then
                CarryOut <= '1';
            else
                CarryOut <= '0';
            end if;

            -- Final Result
            AluResult <= Y(15 downto 0);
        end process;
end RTL;
