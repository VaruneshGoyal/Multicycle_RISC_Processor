library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library work;
use work.Microprocessor_project.all;

-- helps choose from 2^n inputs ( 16 bit vector) using n control bits

entity Data_MUX is
generic (control_bit_width:integer);
port(Din:in Data_in( 2**control_bit_width downto 0);
	Dout:out std_logic_vector(15 downto 0);
	control_bits:in std_logic_vector(control_bit_width-1 downto 0)
);
end Data_MUX;


architecture  Formula_mux of Data_MUX is
signal indice:integer;
begin


indice <= to_integer(unsigned(control_bits));
 Dout <= Din(indice);
end Formula_mux;
