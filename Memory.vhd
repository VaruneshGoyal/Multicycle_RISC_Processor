
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library work;
use work.Microprocessor_project.all;

entity Memory is
port ( Din: in std_logic_vector(15 downto 0);
	Dout: out std_logic_vector(15 downto 0);
	write_enable,read_enable,clk: in std_logic;
	--write_enable,read_enable: in std_logic;
	Addr: in std_logic_vector(15 downto 0)
);
end Memory;

architecture Formula_Memory of Memory is
signal Data :Data_in(65535 downto 0):= (
0 => "0100001000001010", -- Lw r0, r1, 10
1 => "0100010000001011", -- Lw r1, r2, 11
2 => "0100011000001010", -- LM from loc5. put in r0, r2, r4, r6
3 => "0100100000001011", 
4 => "0100101000001010", 	
5 => "0100110000001011", 
6 => "0111000000000000", 
7 => "0000000000000011",
8 => "0111000000001111",
9 => "1100100101001010",
10 =>"0000000000000001",
11 =>"0100000000001100",
12 =>"0000000000000011",
13 =>"0000000000000100",
14 =>"0000000000000101",
others=>"0000000111010010"
);


begin
 process(clk)		--process(clk)
    begin
        
               --Dout <= Data(to_integer(unsigned(Addr)));
        if (clk'event and (clk  = '0')) then
                if (write_enable = '1') then
                    Data(to_integer(unsigned(Addr))) <= Din  ;
                end if;
		if (read_enable = '1') then
                   Dout<= Data(to_integer(unsigned(Addr)))   ;
                end if;

        end if;
    end process;

end Formula_Memory;
