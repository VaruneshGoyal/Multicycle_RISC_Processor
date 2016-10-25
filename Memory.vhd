
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library work;
use work.Microprocessor_project.all;

entity Memory is
port ( Din: in std_logic_vector(15 downto 0);
	Dout: out std_logic_vector(15 downto 0);
	write_enable,read_enable,clk: in std_logic;
	Addr: in std_logic_vector(15 downto 0)
);
end Memory;

architecture Formula_Memory of Memory is
signal Data :Data_in(65535 downto 0):= (
0 => "0100000001001010", -- Lw r0, r1, 10
1 => "0100001010001010", -- Lw r1, r2, 10
2 => "0000100000001000", -- ADD r4,r1,r0
3 => "0000000000000001",
4 => "0000000000000011",
5 => "0000000000000100",
6 => "0000000000000101",
7 => "0000000000000110",
8 => "0110001001111100",
9 => "1100100101001010",
10 =>"0000000000000100",
others=>"0000000111010010"
);




begin
 process(clk)
    begin
        
               --Dout <= Data(to_integer(unsigned(Addr)));
        if falling_edge(clk) then
                if (write_enable = '1') then
                    Data(to_integer(unsigned(Addr))) <= Din  ;
                end if;
		if (read_enable = '1') then
                   Dout<= Data(to_integer(unsigned(Addr)))   ;
                end if;

        end if;
    end process;

end Formula_Memory;
