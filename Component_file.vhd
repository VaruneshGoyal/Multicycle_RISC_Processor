library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

package Microprocessor_project is
type Data_in is array (natural range <>) of std_logic_vector(15 downto 0);

component priority_encoder is
port(  
	x: in std_logic_vector(7 downto 0);
	y: out std_logic_vector(2 downto 0)
       
 );
end component;

component decoder_pe is
port(  x: in std_logic_vector(2 downto 0);
	y: out std_logic_vector(7 downto 0)
	
       
 );
end component;

component DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0);
	      clk, enable: in std_logic);
end component;

component Data_MUX is
generic (control_bit_width:integer);
port(Din:in Data_in( 7 downto 0);
	Dout:out std_logic_vector(15 downto 0);
	control_bits:in std_logic_vector(control_bit_width-1 downto 0)
);
end component;

component Memory is
port ( Din: in std_logic_vector(15 downto 0);
	Dout: out std_logic_vector(15 downto 0);
	write_enable,clk: in std_logic;
	Addr: in std_logic_vector(15 downto 0)
);
end component;

component Reg_File is

port( A1,A2,A3: in std_logic_vector(2 downto 0);
      D1, D2: out std_logic_vector(15 downto 0);
      write_enable,clk: in std_logic;
      pc_enable:in std_logic;
      D3: in std_logic_vector( 15 downto 0)
);

end component;
end package;

