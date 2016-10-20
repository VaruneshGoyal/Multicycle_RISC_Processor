
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library work;
use work.Microprocessor_project.all;

entity Memory is
port ( Din: in std_logic_vector(15 downto 0);
	Dout: out std_logic_vector(15 downto 0);
	write_enable,clk: in std_logic;
	Addr: in std_logic_vector(15 downto 0)
);
end Memory;

architecture Formula_Memory of Memory is
signal Data :Data_in(65535 downto 0);



begin
 process(clk)
    begin
        
                Dout <= Data(to_integer(unsigned(Addr)));
        if falling_edge(clk) then
                if (write_enable = '1') then
                    Data(to_integer(unsigned(Addr))) <= Din  ;
                end if;
        end if;
    end process;

end Formula_Memory;
